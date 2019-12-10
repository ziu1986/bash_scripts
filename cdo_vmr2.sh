#! /bin/bash
#----------------------------------------------------------------------------
#
# Transform OsloCTM3 output from g/cm3 to mol/mol (tropospheric tracers)
#
#----------------------------------------------------------------------------
usage=$"Transform Oslo CTM3 tracer output from g/cm3 to mol/mol. 
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

Mair=28.9644
MO3=47.9982
MSO2=64.066
MNO2=46.0055
MCO=28.01
# Loop all files
for infile1 in `ls ${srcdir}*.nc` ; do
    infile2=${infile1/"trp"/"air"}
    infile2=${infile2/"trop_tracer"/"air_density"}
    outfile=${infile1/"trp"/"vmr_ozone"}
    #outfile=${infile1/"trp"/"vmr_no2"}
    #outfile=${infile1/"trp"/"vmr_co"}
    # Sulfur
    #infile2=${infile1/"sulphur"/"air_density"}
    #infile2=${infile2/"/sul"/"/air"}
    #outfile=${infile1/"/sul"/"/vmr_so2"}
    outfile=`basename ${outfile}`
    
    if [[ ! -e ${outfile} ]]; then
        # Convert from g/cm3 to mol/mol
        if [[ $select_level -eq 1 ]]; then
            #echo $infile1 $outfile
            cdo -L mulc,$Mair -divc,$MO3 -div -sellevidx,1 -selname,O3 ${infile1} -selname,air_densit ${infile2} ${outfile}
            #cdo mulc,$Mair -divc,$MSO2 -div -sellevidx,1 -selname,SO2 ${infile1} -selname,air_densit ${infile2} ${outfile}
            #cdo mulc,$Mair -divc,$MNO2 -div -sellevidx,1 -selname,NO2 ${infile1} -selname,air_densit ${infile2} ${outfile}
            #cdo mulc,$Mair -divc,$MCO -div -sellevidx,1 -selname,CO ${infile1} -selname,air_densit ${infile2} ${outfile}
        else
            #echo $infile1 $outfile
            cdo -L mulc,$Mair -divc,$MO3 -div -selname,O3 ${infile1} -selname,air_densit ${infile2} ${outfile}
            #cdo mulc,$Mair -divc,$MSO2 -div -selname,SO2 ${infile1} -selname,air_densit ${infile2} ${outfile}
            #cdo mulc,$Mair -divc,$MNO2 -div -selname,NO2 ${infile1} -selname,air_densit ${infile2} ${outfile}
            #cdo mulc,$Mair -divc,$MCO -div -selname,CO ${infile1} -selname,air_densit ${infile2} ${outfile}
        fi
        # Rename variable
        ncrename -v .air_densit,"O3" ${outfile}
        #ncrename -v .air_densit,"SO2" ${outfile}
        #ncrename -v .air_densit,"NO2" ${outfile}
        #ncrename -v .air_densit,"CO" ${outfile}
        # Change netcdf units attribute
        ncatted -a units,"O3",m,c,"mol/mol" ${outfile}
        #ncatted -a units,"SO2",m,c,"mol/mol" ${outfile}
        #ncatted -a units,"NO2",m,c,"mol/mol" ${outfile}
        #ncatted -a units,"CO",m,c,"mol/mol" ${outfile}
    fi
    
done

cd ..
# Concatenate the files
# Ozone
echo "Concatenating ${outfile:0:13}.nc"
cdo cat VMR/*.nc "${outfile:0:13}.nc"
# All except ozone
#echo "Concatenating ${outfile:0:10}.nc"
#cdo cat VMR/*.nc "${outfile:0:10}.nc"

# Delete the temporary files
if [[ -e '${outfile:0:13}.nc' ]]; then
    echo "Removing the temporary files in VMR."
    rm -r VMR
done

