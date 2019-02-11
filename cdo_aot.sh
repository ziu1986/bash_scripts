#! /bin/bash
#----------------------------------------------------------------------------
#
# Interpolate surface ozone fields time wise and compute AOT40
#
#----------------------------------------------------------------------------
usage=$"Compute AOTx from given O3 field in OsloCTM3 output. 
              ./cdo_aot <path> <aotx>
Valid choices: aot40"

srcdir=${1}
aottype=${2}

tmp_outfile=tmp_output.nc
basedir=`dirname $srcdir`

case $aottype in
    aot40)
        trhold=40
        ;;
    *)
        echo "No valid threshold chosen!"
        echo "${usage}"
        exit
esac

cd $basedir

# Make directory
if [ ! -d  $aottype ]; then
    mkdir $aottype
fi

# Change to result directory
cd $aottype

# Loop all files
for infile1 in `ls ${srcdir}*` ; do
    infile2=${infile1/"trop_tracer/trp"/"air_density/air"}
    outfile=${infile1/"trp"/"${aottype}_"}
    outfile=`basename ${outfile}`
    
    if [[ ! -e ${outfile} ]]; then
        # Convert from g/cm3 to mol/mol
        cdo mulc,28.949 -divc,48 -div -sellevidx,1 -selname,O3 ${infile1} -selname,AIRdnsty ${infile2} ${outfile}
        # Change netcdf units attribute
        ncatted -a unit,'AIRdnsty',m,c,'mol/mol' ${outfile}
        # Rename variable
        ncrename -v AIRdnsty,"O3" ${outfile}
    fi
    
done
# Concatenate the files
catfile=${outfile/_???.nc/".nc"}
if [[ ! -e $catfile ]]; then
    echo "Concatenate file: $catfile"
    cdo cat `ls *_???.nc` $catfile
fi

# Interpolate temporally
#cdo intntime,3 ${catfile} "tmp_${catfile}"
# Subtract ${trhold} and mask all entries which are below 0
if [[ ! -e $tmp_outfile ]]; then
    cdo -mul ${catfile} -gec,0 -subc,${trhold} -mulc,1e9 ${catfile} $tmp_outfile
fi

# Time integration
outfile="${aottype}.nc"
cdo timsum -mulc,3 $tmp_outfile $outfile

#rm tmp_${catfile}
# Remove tmporary files
rm `ls *_???.nc`
rm $tmp_outfile
