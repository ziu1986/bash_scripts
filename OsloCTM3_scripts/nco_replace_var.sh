#! /bin/bash
usage() { echo "${0} <source_file> -d <change_value> -v <variable_name>"; exit 1; }


#while getopts ":d:v:" options; do
#    case "${options}" in
#        -d)
#            delta_T=${OPTARG}
#            echo "delta T = $delta_T"
#            ;;
#        -v)
#            var=${OPTARG}
#            ;;
#        *)
#            usage
#            ;;
#    esac
#done
#shift $((OPTIND -1))

src=${1}
delta_T=${2}
var=${3}
# Seperate name and directory
src_dir=`dirname ${src}`
file_name=`basename ${src}`
# Construct the target directory
tgt="temp_${delta_T/./_}"
tgt_dir=$src_dir/$tgt
# Temporary files
tmp_file="tmp.nc"
tmp_nco="tmp_nco.nc"

# Variable name
#var="temperature_2m"
# Make copy of original file
if [ ! -d $tgt_dir ]; then
    echo "Make direrctory $src_dir/$tgt_dir"
    mkdir $tgt_dir
fi

if [ ! -e $tgt_dir/$file_name ]; then
    echo "Copy $src ->  $tgt_dir/$file_name"
    cp $src $tgt_dir/
fi

echo "Change $var in $src and save to $tgt_dir/$tmp_file."
cdo -b 64 addc,$delta_T -selname,$var $src $tgt_dir/$tmp_file
echo "Change to target directory"
cd $tgt_dir
echo `pwd`
echo "Add new $var to $file_name."
ncks -x -v $var $file_name $tmp_nco
ncks -A -v $var $tmp_file $tmp_nco
echo "Move $tmp_nco $file_name."
mv $tmp_nco $file_name
echo "Remove $tmp_file"
rm $tmp_file

exit 0
