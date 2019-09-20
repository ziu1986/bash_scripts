#! /bin/bash
#----------------------------------------------------------------------------
#
# Interpolate surface ozone fields time wise
#
#----------------------------------------------------------------------------
usage=$"Sort and interpolate surface ozone fields from MACC reanalyisi time wise
        Run cdo_vmr2.sh first!
              ./cdo_aot_macc <vmr ozone file>
        Execute python aot40.py afterwards."

infile=${1}

if [ -z "${infile}" ]; then
    echo $usage
    exit
fi

basedir=`dirname $infile`

# Make directory
if [ ! -d  tmp ]; then
    mkdir tmp
fi

outfile=${infile/"vmr"/"interp"}
outfile=`basename ${outfile}`

# Interpolate to 1-hourly
#cdo intntime,3 ${infile} ${outfile}
cdo intntime,3 -sorttimestamp ${infile} tmp/${outfile}

