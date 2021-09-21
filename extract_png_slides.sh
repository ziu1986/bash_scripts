#! /bin/bash
INPUT=${1}
OUTPUT_DIR=${2}

if [ ! -d $OUTPUT_DIR ]; then
    mkdir -p $OUTPUT_DIR
fi

SEPERATOR="`basename ${INPUT} .pdf`_%d.pdf"

pdfseparate $INPUT $OUTPUT_DIR/$SEPERATOR

cd $OUTPUT_DIR

for each in `ls *.pdf`; do
    png_file="`basename ${each} .pdf`.png"
    echo $each $png_file
    pdftoppm -png $each > $png_file
done
    
 
