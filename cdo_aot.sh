#! /bin/bash
#----------------------------------------------------------------------------
#
# Interpolate surface ozone fields time wise and compute AOT40
#
#----------------------------------------------------------------------------
usage=$"Compute AOTx from given O3 field in OsloCTM3 output.
        Run cdo_vmr2.sh first!
              ./cdo_aot <vmr ozone file> <aotx>
Valid choices: aot40"

infile=${1}
aottype=${2}

tmp_outfile=tmp_output.nc
basedir=`dirname $srcdir`

case $aottype in
    aot40)
        trhold=40
        ;;
    aot30)
        trhold=30
        ;;
    *)
        echo "No valid threshold chosen!"
        echo "${usage}"
        exit
esac

cd $basedir
echo "Change to `pwd`"
# Make directory
if [ ! -d  $aottype ]; then
   
    mkdir $aottype
fi

# Change to result directory
cd $aottype

outfile=${infile/"vmr"/"${aottype}"}
outfile=`basename ${outfile}`

# Interpolate to 1-hourly
#cdo intntime,3 ${infile} ${outfile}
cdo intntime,3 -sorttimestamp ${infile} ${outfile}

# Subtract ${trhold} and mask all entries which are below 0
if [[ ! -e $tmp_outfile ]]; then
    cdo -mul ${outfile} -gec,0 -subc,${trhold} -mulc,1e9 ${outfile} $tmp_outfile
fi

# Time integration
outfile="${aottype}.nc"
#cdo timsum $tmp_outfile ${basedir}/$outfile

#rm $tmp_outfile
# Remove tmporary files
#rm `ls *_???.nc`
#rm $tmp_outfile
