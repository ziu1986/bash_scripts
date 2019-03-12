#! /bin/bash
#----------------------------------------------------------------------------
#
# Select 10 m wind components from OpenIFS output and concatenate them.
#
#----------------------------------------------------------------------------
usage=$"Select 10 m wind components from OpenIFS output and concatenate them.
              ./cdo_sel_cat.sh <path_to_ozone_files>"

srcdir=${1}

tmp_outfile=tmp_output.nc
basedir=`dirname $srcdir`
selection='wind'

# Make directory
if [ ! -d  $selection ]; then
    mkdir $selection
fi
cd $selection
echo `pwd`

# Loop all files
for infile in `ls ${srcdir}/*/*.nc` ; do
    outfile=`basename ${infile}`
    echo $outfile
    outfile="${selection}_${outfile}"
    echo $outfile
    cdo selname,U10M,V10M ${infile} ${outfile}
done

echo "Concatenating files."
cdo cat *.nc "${outfile:0:25}.nc"
mv "${outfile:0:25}.nc" ..
cd ..
rm -r "${selection}/"
