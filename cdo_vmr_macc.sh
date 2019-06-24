#! /bin/bash
#----------------------------------------------------------------------------
#
# Transform OsloCTM3 output from kg to mol/mol
#
#----------------------------------------------------------------------------
usage=$"Transform ECMWF MACC reanalysis output from kg/kg to mol/mol. 
              ./cdo_vmr_macc.sh <path_to_ozone_files>"

srcdir=${1}
cd $srcdir
if [ ! -d "VMR" ]; then
   mkdir "VMR"
fi
   
for file in `ls macc*.nc` ; do
    infile=`basename $file`
    outfile=vmr_$infile
    #echo $infile, $outfile
    cdo mulc,28.9644 -divc,47.9982 -selname,go3 $infile $outfile
    ncatted -a units,"go3",m,c,"mol/mol" ${outfile}
    mv $outfile VMR/
done


