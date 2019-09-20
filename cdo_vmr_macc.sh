#! /bin/bash
#----------------------------------------------------------------------------
#
# Transform OsloCTM3 output from kg to mol/mol
#
#----------------------------------------------------------------------------
usage=$"Transform ECMWF MACC reanalysis output from kg/kg to mol/mol. 
              ./cdo_vmr_macc.sh <ozone_file>"

src=${1}
srcdir=`dirname $src`
cd $srcdir
if [ ! -d "VMR" ]; then
   mkdir "VMR"
fi
   
infile=`basename $src`
outfile=vmr_$infile
#echo $infile, $outfile
cdo mulc,28.9644 -divc,47.9982 -selname,go3 $infile $outfile
ncatted -a units,"go3",m,c,"mol/mol" ${outfile}
mv $outfile VMR/



