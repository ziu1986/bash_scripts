#! /bin/bash
INFILE=${1}
OUTFILE=${2}
GRIDFILE_DIR=$PY_SCRIPTS/regridding
# "regrid_drydep", "regrid_ozone", "regrid_pft", "regrid_macc", "regrid_vo3"
mode='regrid_ozone'
# Grids: hardacre_grid, osloctm3_grid, macc_grid
src_grid="osloctm3_grid"
tgt_grid="hardacre_grid"

if [ ! $INFILE ]; then 
   echo "Usage: cdo_regrid INPUTFILE <OUTPUTFILE>"
   exit
fi
if [ ! $OUTFILE ]; then
    OUTFILE=`basename ${INFILE}`
    echo "No outfile name specified."
    echo "Use ${OUTFILE}"
fi
OUTDIR=`dirname ${INFILE}`
echo "Output dir: $OUTDIR"
echo "Regriding data... ${INFILE}"

case ${mode} in
 "regrid_drydep") # Dry deposition
     cdo remapycon,${GRIDFILE_DIR}/${tgt_grid}.txt -selname,dry_O3,gridarea -setgrid,${GRIDFILE_DIR}/${src_grid}.txt ${INFILE} ${OUTFILE}
     # Add the lost meta data (YEAR, MONTH, VERSION, tracer_name)
     echo "Adding lost meta data..."
     ncks -A -v YEAR,MONTH,tracer_name,tracer_idx,tracer_molweight,VERSION ${INFILE} ${OUTFILE}
     ;;
 "regrid_ozone") # Ozone
     cdo remapycon,${GRIDFILE_DIR}/${tgt_grid}.txt -selname,O3,gridarea,height -setgrid,${GRIDFILE_DIR}/${src_grid}.txt ${INFILE} ${OUTFILE}
     # Add the lost meta data (YEAR, MONTH, VERSION, tracer_name)
     echo "Adding lost meta data..."
     ncks -A -v YEAR,MONTH,tracer_name,tracer_idx,tracer_molweight,VERSION ${INFILE} ${OUTFILE}
     ;;
 "regrid_pft") # Plant function types
     src_grid="pft_pct_grid"
     tgt_grid="hardacre_grid"
     cdo remapycon,${GRIDFILE_DIR}/${tgt_grid}.txt -selname,PFT_PCT -setgrid,${GRIDFILE_DIR}/${src_grid}.txt ${INFILE} ${OUTFILE}
     ;;
 "regrid_macc") # MACC
     src_grid="macc_grid"
     tgt_grid="osloctm3_grid"
     cdo remapycon,${GRIDFILE_DIR}/${tgt_grid}.txt -selname,go3 -setgrid,${GRIDFILE_DIR}/${src_grid}.txt ${INFILE} ${OUTFILE}
     ;;
 "regrid_vo3") # Dry deposition velocities
     cdo remapycon,${GRIDFILE_DIR}/${tgt_grid}.txt -selname,VO3,gridarea -setgrid,${GRIDFILE_DIR}/${src_grid}.txt ${INFILE} ${OUTFILE}
     # Add the lost meta data (YEAR, MONTH, VERSION, tracer_name)
     echo "Adding lost meta data..."
     ncks -A -v YEAR,MONTH,tracer_name,tracer_idx,tracer_molweight,VERSION ${INFILE} ${OUTFILE}
     ;;
 *)
     "No valid option. Options: regrid_drydep, regrid_ozone, regrid_pft, regrid_macc, regrid_vo3"
     exit
esac

if [ ! -d ${OUTDIR}/${tgt_grid} ]; then
    echo "Making directory: ${OUTDIR}/${tgt_grid}"
    mkdir ${OUTDIR}/${tgt_grid}
fi

echo "Moving output..."
mv ${OUTFILE} ${OUTDIR}/${tgt_grid}
