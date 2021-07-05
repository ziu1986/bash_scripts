#!/bin/bash
month=('01' '02' '03' '04' '05' '06' '07' '08' '09' '10' '11' '12')
#------------------------------------------------------------------------

# Set the workdirectory
#WORKDIR=$DATA/astra_data/ctm_results/C3RUN_default
WORKDIR=${1}
DESTDIR=scavenging_monthly
# Dummy names
ifiles=scavenging_daily/scavenging_daily_2d_2005
ofile=scavenging_2005
# Change to work directory
cd $WORKDIR

# Now loop over all months to concatenate the daily files
# and compute the monthly average 
for imonth in ${month[@]}; do
    # Select all files in month
    input=${ifiles}${imonth}*.nc
    output=${ofile}${imonth}_2d.nc
    # Merge in a temporary file
    if [ ! -e ${output} ]; then
        echo "Merging files..."
        cdo cat ${input} ${output}
    fi
    # Compute monthly average
    #output_mm=mm_`basename ${output}`
    # Compute monthly sums
    output_sum=sum_`basename ${output}`
    if [ ! -e ${output_mm} ]; then
        #echo "Computing the average..."
        #cdo timavg ${output} ${output_mm}
        echo "Computing the sums..."
        cdo timsum ${output} ${output_sum}
    fi
    # Add the lost meta data (YEAR, MONTH, VERSION, tracer_name)
    echo "Adding lost meta data..."
   # ncks -A -v YEAR,MONTH,tracer_name,VERSION ${ifiles}${imonth}01.nc ${output_mm}
    ncks -A -v YEAR,MONTH,tracer_name,VERSION ${ifiles}${imonth}01.nc ${output_sum}
    echo "Deleting temporary files..."
    rm ${output}
    if [ ! -d ${DESTDIR} ]; then
        echo "Create dwelling..."
        mkdir ${DESTDIR}
    fi
    #mv ${output_mm} ${DESTDIR}
    mv ${output_sum} ${DESTDIR}
done
