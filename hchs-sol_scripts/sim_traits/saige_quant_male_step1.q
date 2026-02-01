#!/bin/bash

#SBATCH --job-name=150s1noloco_male
#SBATCH --output=s1noloco_male_150.out
#SBATCH --account=pro00108518
#SBATCH --mem=75G
#SBATCH --array=1-10
#SBATCH --ntasks-per-node=24
#SBATCH --mail-user=tiffany.tu@duke.edu
#SBATCH --mail-type=END,FAIL

rep_num=$((SLURM_ARRAY_TASK_ID))
# Run R scripts for male
echo "Running for male: $trait and $age_trait"
time Rscript saige_step1_quant_sex.R -s male -a "$rep_num" -l 0





