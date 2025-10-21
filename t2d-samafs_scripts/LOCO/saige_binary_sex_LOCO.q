#!/bin/bash

#SBATCH --job-name=samafs_binary_sex
#SBATCH --output=samafs_binary_t2d_sex-chr%a.out
#SBATCH --mem=100G
#SBATCH --array=1-22
#SBATCH --ntasks-per-node=24
#SBATCH --mail-user=tiffany.tu@duke.edu
#SBATCH --mail-type=END,FAIL

chr_num=$((SLURM_ARRAY_TASK_ID))
#time Rscript saige_step1_sex_LOCO.R -s male
time Rscript saige_step2_sex_LOCO.R -s male -c "$chr_num"

#time Rscript saige_step1_sex_LOCO.R -s female
time Rscript saige_step2_sex_LOCO.R -s female  -c "$chr_num"


