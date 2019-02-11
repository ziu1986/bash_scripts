#!/bin/bash
#----------------------------------------------------------------------------
#
#  Compute PODy from given FstO3 instantaneous values
#
#----------------------------------------------------------------------------
usage=$"Compute PODy from given FstO3_inst field in OsloCTM3 output. 
              ./cdo_pod <path> <pody>
Valid choices: pod1, pod2, pod3"

srcdir=${1}
podtype=${2}
#podtype=pod3
#srcdir=$DATA/astra_data/ctm_results/C3RUN_emep_full_2005/scavenging_daily/
#srcdir=$DATA/abel/C3RUN_emep_ppgs.130818.23552/scavenging_daily/
#srcdir=$DATA/abel/C3RUN_emep_ppgs_2005.140818.18140/scavenging_daily/

tmp_outfile=tmp_output.nc

case $podtype in
    pod1)
        trhold=1
        ;;
    pod2)
        trhold=2
        ;;
    pod3)
        trhold=3
        ;;
    *)
        echo "No valid threshold chosen!"
        echo "${usage}"
        exit
esac

# Make directory
if [ ! -d  $podtype ]; then
    mkdir $podtype
fi

# Change to result directory
cd $podtype
# Loop all files
for infile in `ls $srcdir/scavenging_daily_stomata_*.nc`; do
    echo "Input: ${infile}"         
    echo "Output: ${outfile}"
    outfile=`basename $infile`
    outfile=${outfile/"scavenging_daily_stomata"/$podtype}
   
    # Subtract ${trhold} and mask all entries which are below 0
    cdo -mul -selname,FstO3_inst $infile -gec,0 -subc,${trhold} -selname,FstO3_inst $infile $tmp_outfile
    # Time integration
    cdo mulc,1e-6 -timsum -mulc,3600 -selname,FstO3_inst $tmp_outfile $outfile
    # Remove temporary files
    rm $tmp_outfile
    # Change netcdf units attribute
    ncatted -a unit,'FstO3_inst',m,c,'mmol meter-2' $outfile
    # Rename variable FstO3_inst -> $podtype_daily
    ncrename -v FstO3_inst,"${podtype}_daily" $outfile
done
# Concatenate the files
catfile=${outfile/_???.nc/".nc"}
echo "Concatenate file: $catfile"
cdo cat `ls *_???.nc` $catfile
# Remove single files
rm `ls *_???.nc`
# Compute annual sum
cdo timsum $catfile "sum_"$catfile
# Move results to src directory
cd ..
destdir=`dirname $srcdir`
if [ ! -d $destdir/$podtype ]; then
    mv $podtype $destdir
else
    mv $podtype/* $destdir/$podtype
fi

