#! /bin/bash
#------------------------------------------------------------------------
# Job name:
#SBATCH --job-name=cdo_gcm32vmr
#
# Project:
#SBATCH --account=nn2806k
#
# Wall clock limit:
#SBATCH --time=0:30:0
#
# Max memory usage:
#SBATCH --mem-per-cpu=4000M

## Set up job environment:
#source /cluster/bin/jobsetup
#module purge   # clear any inherited modules
module load CDO/1.9.8-intel-2019b
module load NCO/4.9.1-intel-2019b
set -o errexit # exit on errors
#-----------------------------------------------------------------------
#----------------------------------------------------------------------------
#
# Transform OsloCTM3 output from g/cm3 to mol/mol
#
#----------------------------------------------------------------------------


usage() {
    echo "Transform Oslo CTM3 tracer output from g/cm3 to mol/mol."
    echo "./cdo_gcm32vmr.sh [--surface] --variable <val> --molecularmass <val> <case directory> "
    exit 1
}

check_null()
{
    if [ $# -eq 0 ]; then
        echo "No arguments provided!"
        usage
        exit 1
    fi
}

options()
{
    # Option parser
    srcdir=${@: -1}
    while [ "${1}" != "" ]; do
        
        case $1 in
            --molecularmass )
                molecularmass=${2}
                echo "Molecular mass: ${molecularmass}"
                shift
                ;;
            --variable )
                variable=${2}
                echo "Variable: ${variable}"
                shift
                ;;
            --surface )
                opttype=1
                echo "Option: ${opttype}"
                ;;
            -h | --help )
                usage
                exit
                ;;
            * )
                echo "The source is: ${srcdir}"
                ;;
        esac
        shift
    done
}


convert_to_vmr() {
    # Function to convert from g%cm3 to VMR
    basedir=`dirname $srcdir`

    cd VMR
    echo "Working dir:" `pwd`

    Mair=28.9644
    #MO3=47.9982
    #MSO2=64.066
    #MNO2=46.0055
    #MCO=28.01
    # Loop all files
    for infile1 in `ls ${srcdir}*.nc` ; do
        # Replace the string "trp" with "air"
        infile2=${infile1/"trp"/"air"}
        # Replace "trop_tracer" with "air_density"
        infile2=${infile2/"trop_tracer"/"air_density"}
        # Replace "trp"with variable name
        outfile=${infile1/"trp"/"vmr_${variable}"}
        # Make sure it is saved "inplace" and not in the source directory
        outfile=`basename ${outfile}`
        echo $outfile
        if [[ ! -e ${outfile} ]]; then
            # Convert from g/cm3 to mol/mol
            echo "Computing VMR."
            if [[ $opttype -eq 1 ]]; then
                #echo $infile1 $outfile
                # mulc = cdo command for multiplying with a constant
                # $Mair = mass of air
                # divc = cdo command for dividing by a constant
                # div = cdo command for dividing two fields
                # sellevidx = cdo command for selecting levels by index, here only level 1 is chosen.
                # ${outfile} = put result in the outfile.
                # what this calculates: (molecularmass_air/molecularmass_variable)*(mmr_variable/mmr_air)
                # mmr = mass mixing ratio
                cdo -L  mulc,$Mair -divc,${molecularmass} -div -sellevidx,1 -selname,${variable} ${infile1} -selname,air_densit ${infile2} ${outfile}
            else
                #echo $infile1 $outfile
                # does the same as above, except for calculating the whole field, not only the surface.
                cdo -L  mulc,$Mair -divc,${molecularmass} -div -selname,${variable} ${infile1} -selname,air_densit ${infile2} ${outfile}
            fi
            # Rename variable
            echo "Changing variable name."
            ncrename -v .air_densit,${variable} ${outfile}
            # Change netcdf units attribute
            echo "Changing variable unit."
            ncatted -a units,${variable},m,c,"mol/mol" ${outfile}
        fi

    done

    # Leave the working directory
    cd ..
}
    
# Concatenate the files
# Ozone
#echo "Concatenating ${outfile:0:13}.nc"
#cdo -L  cat VMR/*.nc "${outfile:0:13}.nc"
# All except ozone
#echo "Concatenating ${outfile:0:10}.nc"
#cdo -L  cat VMR/*.nc "${outfile:0:10}.nc"

# Delete the temporary files
#if [[ -e ${outfile:0:13}.nc ]]; then
#    echo "Removing the temporary files in VMR."
#    rm -r VMR
#done

## MAIN

check_null $@

options $@

# Test for given case directory
if [ -z "${srcdir}" ]; then
    echo "Error: No source directory specified."
    exit
fi

# Test for given variable
if [ -z "${variable}" ]; then
    echo "Error: No variable specified."
    exit
fi

# Test for given molecularmass
if [ -z "${molecularmass}" ]; then
    echo "Error: No molecular mass specified."
    exit
fi

convert_to_vmr

exit
