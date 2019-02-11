#! /bin/bash
INFILE=${1}
OUTFILE=${2}
GRIDFILE_DIR=$PY_SCRIPTS/OsloCTM3/

if [ ! $INFILE ]; then 
   echo "Usage: regrid_cdo INPUTFILE <OUTPUTFILE>"
   exit
fi
if [ ! $OUTFILE ]; then
    OUTFILE="regrid_hardacre_`basename ${INFILE}`"
    echo "No outfile name specified."
    echo "Use ${OUTFILE}"
fi
OUTDIR=`dirname ${INFILE}`
echo "Output dir: $OUTDIR"
echo "Regriding data... ${INFILE}"
# Dry deposition
#cdo remapycon,${GRIDFILE_DIR}/hardacre_grid.txt -selname,dry_O3,gridarea -setgrid,${GRIDFILE_DIR}/osloctm3_grid.txt ${INFILE} ${OUTFILE}
# Ozone
cdo remapycon,${GRIDFILE_DIR}/hardacre_grid.txt -selname,O3,gridarea,height -setgrid,${GRIDFILE_DIR}/osloctm3_grid.txt ${INFILE} ${OUTFILE}
# Plant function types
##cdo remapycon,${GRIDFILE_DIR}/hardacre_grid.txt -selname,PFT_PCT -setgrid,${GRIDFILE_DIR}/pft_pct_grid.txt ${INFILE} ${OUTFILE}
#
# Add the lost meta data (YEAR, MONTH, VERSION, tracer_name)
echo "Adding lost meta data..."
ncks -A -v YEAR,MONTH,tracer_name,tracer_idx,tracer_molweight,VERSION ${INFILE} ${OUTFILE}

if [ ! -d ${OUTDIR}/regrid_hardacre ]; then
    echo "Making directory: ${OUTDIR}/regrid_hardacre"
    mkdir ${OUTDIR}/regrid_hardacre
fi

echo "Moving output..."
mv ${OUTFILE} ${OUTDIR}/regrid_hardacre
