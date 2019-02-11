#! /bin/bash
# stop on error
set -e
#----------------------------------------------------------------------------
#
# Interpolate surface ozone fields time wise and compute AOT40
#
#----------------------------------------------------------------------------
cd $PY_SCRIPTS/ozone_metrics/
project=$DATA'/abel/C3RUN_emep_SWVL4.231018.32284/'
# g/cm3 -> mol/mol
# subtract 40 ppb and mask all that is below 0
python compute_aot40.py

# Concatenate output files
echo "Concatenating..."
cdo cat `ls aot40_2005_???.nc` aot40_2005.nc
cdo -selname,O3 aot40_2005.nc O3_2005.nc
# Remove single files
echo "Removing... aot40_2005_???.nc"
rm aot40_2005_???.nc

if [[ ! -d aot40 ]]; then
    echo "Make directory aot40..."
    mkdir aot40
fi

# Interpolate to 1 hourly resolution
echo "Interpolate to 1 hourly resolution..."
cdo inttime,2005-01-01,00:00:00,1hour aot40_2005.nc tmp_aot40_2005.nc

# Integrate daily AOT40 8-20
python compute_aot40_daily.py
# Move results
mv aot40_2005.nc aot40
mv sum40_2005.nc aot40
# Remove tmp file
rm tmp_aot40_2005.nc

mv aot40 $project
