#! /bin/bash
usage="./nco_replace_var.sh <source_file> <target_directory>"

src=${1}
tgt=${2}

src_dir=`dirname ${src}`
file_name=`basename ${src}`
tgt_dir=$src_dir/$tgt
# Variable name
var="temperature_2m"
# Make copy of original file
if [ ! -d $tgt_dir ]; then
    echo "Make direrctory $src_dir/$tgt_dir"
    mkdir $tgt_dir
fi

echo "Copy $src $file_name"
cp $src $tgt_dir/

echo "Change $var and save to tmp."
echo "$file_name tmp.nc"
cdo -b 64 addc,1.5 -selname,temperature_2m $src $tgt_dir/tmp.nc
echo "Change to target directory"
cd $tgt_dir
echo `pwd`
echo "Add new $var to $file_name."
ncks -x -v $var $file_name tmp2.nc
ncks -A -v $var tmp.nc tmp2.nc
mv tmp2.nc $file_name
echo "Remove tmp.nc."
rm tmp.nc
