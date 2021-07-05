#! /bin/bash
#
# This is a comment
#
# This script shall select a variable from OsloCTM3 output with cdo and compute $# concatenate the results.
#
# Comand line arguments can be selected by their sequencial number, eg ${1}
#
# Before executing the script it has to be made executable on unix! To do so:
#
# chmod +x cdo_zonal_mean.sh
#
mkdir tmp #make a directory for the temporary files

for input_file in `ls ${1}*0??.nc`; do #loop over every file in the given directory$
  output_file=`basename ${input_file}`
  echo ${output_file} # print the name of the output file?
  #cdo zonmean -selname,${2} ${input_file} "tmp/${2}_${output_file}"
  # zonmean: Zonal mean. For every latitude the mean over all longitudes is comp$  #variable of interest by its name.
  # ${2} variable given in commandline ${input_file} select from input file (giv$
  # "tmp/${output_file}" put the files in the tmp directory with the given name.
done #the loop is over
#cdo cat tmp/* ${2}_2014_zonal_mean.nc #merge(concatenate) all the temporary fil$
#rm -rf tmp #delete the temporary directoy
