#!/bin/bash

#SBATCH --job-name=noloco_male
#SBATCH --output=%a_noloco_male.out
#SBATCH --mem=75G
#SBATCH --array=1-10
#SBATCH --ntasks-per-node=24
#SBATCH --mail-user=tiffany.tu@duke.edu
#SBATCH --mail-type=END,FAIL

# For LOCO, set array to the chromosome number:
# time Rscript saige_step1_quant_sex.R -s male -a "$rep_num" -l 1
# chr_num=$((SLURM_ARRAY_TASK_ID))
# for rep_num in {1..10}; do
# 
# time Rscript saige_step2_quant_sex.R -s male -a "$rep_num" -l 1 -c "$chr_num"
# done

# noloco
rep_num=$((SLURM_ARRAY_TASK_ID))
time Rscript saige_step1_quant_sex.R -s male -a "$rep_num" -l 0
time Rscript saige_step2_quant_sex.R -s male -a "$rep_num" -l 0