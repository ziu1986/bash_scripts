#!/bin/bash
# Organize the output of OsloCTM3 runs

if [ "${1} == ''" ] ; then
    echo "Missing source directory!"
    echo "Usage: organize_ctm3_output.sh <results directory>"
    exit
fi
#----Most likely no need to change anything below here-------------------------
subdirs=( "air_density" "emissions" "monthly_means" "seasalt" "nitrate" "trop_strat_exchange" "sulphur" "scavenging_daily" "trop_tracer" "non-transp" )
files=( "air" "emis" "avgsav" "slt" "snn" "ste" "sul" "scavenging_daily" "trp" "ntr" )
cd $SRC
echo `pwd`
i=0
for sdir in ${subdirs[@]}; do
    if [ ! -d $sdir ]; then
        mkdir $sdir
    fi
    output=${files[i]}
    mv ${output}* $sdir
    i=$(($i + 1))
done
