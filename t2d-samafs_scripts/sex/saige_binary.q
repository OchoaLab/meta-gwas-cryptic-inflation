#!/bin/bash
#SBATCH -p ochoalab --account=ochoalab
#SBATCH --job-name=samafs_saige_sex
#SBATCH --output=samafs_quant_t2d_sex.out
#SBATCH --mem=100G
#SBATCH --ntasks-per-node=24
#SBATCH --mail-user=tiffany.tu@duke.edu
#SBATCH --mail-type=END,FAIL

input_value=$((SLURM_ARRAY_TASK_ID))

export LD_LIBRARY_PATH=/opt/apps/rhel8/lapack/lib64:$LD_LIBRARY_PATH
module load R/4.1.1-rhel8
# 
time Rscript saige_step1.R -s male
time Rscript saige_step2.R -s male

time Rscript saige_step1.R -s female
time Rscript saige_step2.R -s female

module unload R/4.1.1-rhel8
