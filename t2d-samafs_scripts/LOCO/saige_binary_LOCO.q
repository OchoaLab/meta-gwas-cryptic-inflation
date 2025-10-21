#!/bin/bash

#SBATCH --job-name=samafs_saige
#SBATCH --output=samafs_binary_t2d_%a.out
#SBATCH --mem=100G
#SBATCH --array=1-22
#SBATCH --ntasks-per-node=24
#SBATCH --mail-user=tiffany.tu@duke.edu
#SBATCH --mail-type=END,FAIL

chr_num=$((SLURM_ARRAY_TASK_ID))


#time Rscript saige_step1_LOCO.R 
time Rscript saige_step2_LOCO.R -c "$chr_num"


