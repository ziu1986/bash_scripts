#! /bin/bash
#----------------------------------------------
#
# Extract pmean (mean annual surface pressure)
#
#----------------------------------------------
src=${1}
tgt="P_Mean"
cyc=`dirname ${src}`
met=`dirname ${cyc}`

res=`basename ${src}`
cyc=`basename ${cyc}`
met=`basename ${met}`

# Output file
outfile="${tgt}${res}_${met}_${cyc}.nc"

echo $outfile

# Create a target directory
if [[ ! -e $tgt ]]; then
    mkdir ${tgt}
fi
# Change to target directoy
cd ${tgt}
# loop through files
for month in `ls ${src}`; do
    tmonth=`basename ${month}`
    infiles=`ls ${src}${tmonth}/*`
    if [[ ! -e ${tmonth}"_mean.nc" ]]; then
        # Concatenate the files
        cdo cat -selname,pres_sfc ${infiles} ${tmonth}".nc"
        # Compute the temporal mean
        cdo timmean -selname,pres_sfc ${tmonth}".nc" ${tmonth}"_mean.nc"
        # Rename the variable
        ncrename -v pres_sfc,"Pmean" ${tmonth}"_mean.nc"
        # Remove the concatenated file
        rm ${tmonth}".nc"
    else
        echo "File ${tmonth}_mean.nc already exists. Skip."
    fi
done

# Concatenate files
cdo cat `ls *_mean.nc` "${tgt}.nc"
# Compute annual mean
cdo timmean "${tgt}.nc" ${outfile}
# Remove temporary files
rm ??_mean.nc
rm "${tgt}.nc"
