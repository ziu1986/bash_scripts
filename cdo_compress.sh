#!/bin/sh
#SBATCH --constraint=LSDF
#SBATCH -A hk-project-p0022589
#SBATCH --mail-type=ALL
#SBATCH --mail-user=stefanie.falk@kit.edu
################# do not rerun job if system failure occurs
### KIT
#SBATCH --partition=cpuonly     # dev_cpuonly, dev_accelerated, cpuonly, accelerated 
#SBATCH --ntasks-per-node=1       # cores per node, max 76
#SBATCH --time=0-08:00:00           # maximal 01:00:00 (dev), 3-00:00:00 (cpuonly, accelerated)
#SBATCH --nodes=1                   # maximal 4 (dev), 192 (cpuonly), 56 (accelearted)
export comp='zip_6'
source ~/bin/setpaths

SRC=${WORK} #/hkfs/work/workspace/scratch/uqdyt-Bromopole
TGT=${WORK} #/hkfs/work/workspace/scratch/ki3491-MasterThesis_Reissig

export EXP=EMACT42_sfa008 #EMACT42_lr0002
export SRC_DIR=${SRC}/${EXP}
export TGT_DIR=${TGT}/${EXP}_${comp}

# Check if target doesn't exists
if [[ ! -d ${TGT_DIR} ]]; then
    mkdir ${TGT_DIR}
fi

for i in 1 2 3 4 5 6 7 8 9 10 11 12 ; do # 
    tmp=tmp_${EXP}_${i}.sh
    echo 'module load cdo-2.2.2_i22_ompi40' > ${tmp}
    echo 'for each in `ls ${SRC_DIR}/${EXP}_????0['"${i}"']01*.nc`; do' >> ${tmp}
    echo '    filename=`basename ${each}`' >> ${tmp}
    echo '    new_file=${each/${EXP}/${EXP}_${comp}}' >> ${tmp} 
    echo '    echo $new_file'  >> ${tmp}
    echo '    if [ ! -e $new_file ]; then'  >> ${tmp}
    echo '        echo "cdo"' >> ${tmp}
    echo '        cdo -f nc4c -z ${comp} copy ${each} ${new_file}'  >> ${tmp}
    echo '    fi' >> ${tmp}
    echo 'done' >> ${tmp}
    nohup bash ${tmp} 2>&1 > log_${EXP}_${i} &
done

wait



# Test if everything was processed correctly
#cd ${TGT_DIR}
#if [ -e log ]; then rm log; fi
#for each in `ls .`; do  echo ${each} >> log; cdo -infov -selname,time ${each} >> log 2>&1; done
