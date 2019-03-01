#! /bin/bash
#----------------------------------------------------------------------------
#
# Transform Ozone output from kg to mol/mol
#
#----------------------------------------------------------------------------
usage=$"Transform ozone output from g/cm3 to mol/mol. 
              ./cdo_vmr2.sh <path_to_ozone_files> --surface" 

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
#cd $basedir

# Make directory
if [ ! -d  "VMR" ]; then
    mkdir "VMR"
fi
cd VMR
echo `pwd`

# Loop all files
for infile1 in `ls ${srcdir}*.nc` ; do
    infile2=${infile1/"trp"/"air"}
    infile2=${infile2/"trop_tracer"/"air_density"}
    outfile=${infile1/"trp"/"vmr_ozone"}
    outfile=`basename ${outfile}`
    
    if [[ ! -e ${outfile} ]]; then
        # Convert from g/cm3 to mol/mol
        if [[ $select_level -eq 1 ]]; then
            #echo $infile1 $outfile
            cdo mulc,28.949 -divc,48 -div -sellevidx,1 -selname,O3 ${infile1} -selname,air_densit ${infile2} ${outfile}
        else
            #echo $infile1 $outfile
            cdo mulc,28.949 -divc,48 -div -selname,O3 ${infile1} -selname,air_densit ${infile2} ${outfile}
        fi
        # Rename variable
        ncrename -v .air_densit,"O3" ${outfile}
        # Change netcdf units attribute
        ncatted -a units,"O3",m,c,"mol/mol" ${outfile}
    fi
    
done

cd ..
# Concatenate the files
cdo cat VMR/*.nc ${outfile:0:13}.nc

# Delete the temporary files
echo "Removing the temporary files in VMR."
rm VMR/*
