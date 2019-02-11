#! /bin/bash
#----------------------------------------------------------------------------
#
# Transform Ozone output from g/cm3 to molec/cm3
#
#----------------------------------------------------------------------------
usage=$"Transform ozone output from g/cm3 to molec/cm3. 
              ./cdo_molec <path_to_ozone_files> --surface" 

srcdir=${1}
opttype=${2}

tmp_outfile=tmp_output.nc
basedir=`dirname $srcdir`

case $opttype in
    --surface)
        echo "Selecting surface level."
        select_level=1
        ;;
    *)
        echo "Selecting whole field."
        select_level=0
esac

# Change to working directory
cd $basedir

# Make directory
if [ ! -d  "moleccm3" ]; then
    mkdir "moleccm3"
fi


# Loop all files
for infile1 in `ls trop_tracer/*.nc` ; do
    outfile=${infile1/"trp"/"ozone"}
    outfile=`basename ${outfile}`
    
    if [[ ! -e ${outfile} ]]; then
        # Convert from g/cm3 to mol/mol
        if [[ $select_level -eq 1 ]]; then
            #echo $infile1 $outfile
            cdo divc,48 -sellevidx,1 -selname,O3 ${infile1} moleccm3/${outfile}
        else
            #echo $infile1 $outfile
            cdo divc,48 -selname,O3 ${infile1} moleccm3/${outfile}
        fi
        # Rename variable
        #ncrename -v AIR,"O3" ${outfile}
        # Change netcdf units attribute
        ncatted -a units,"O3",m,c,"molec/cm3" moleccm3/${outfile}
    fi
    
done
