#!/bin/bash
block=( 0 1 2 3 )

# The base directory of the experiment: Change the line below
export WORKDIR=$WORK/C3RUN_1850Spinup1_normNO2.040620.69762

# Make output directory in case it does not exist
if [ ! -d  "VMR" ]; then
    mkdir "VMR"
else
    echo "WARNING: Output directory already exits. Files may be overwritten."
fi

# To build the input file name
export ifiles=trop_tracer/trp
# Loop over the blocks
for iblock in ${block[@]}; do

    # Generate the inputfile name of the junk   

    input="${ifiles}*_${iblock}??"

    # Send the cdo script to the queue   

    sbatch ${HOME}/bin/scripts/osloctm3/cdo_gcm32vmr.sh --variable "CH4" --molecularmass 16.04 $WORKDIR/${input}
done
