#! /bin/bash
pdfseparate slides_EGU21-15000_sf.pdf video/slides_EGU21-15000_sf_%d.pdf
cd video
for each in `ls *.pdf`; do
    png_file=`basename -s .pdf ${each}`.png
    echo $each $png_file
    pdftoppm -png $each > $png_file
done
    
 
