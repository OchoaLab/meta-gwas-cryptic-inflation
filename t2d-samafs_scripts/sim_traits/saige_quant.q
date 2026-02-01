#!/bin/bash

#SBATCH --job-name=noloco_samafs-saige
#SBATCH --output=noloco_samafs-%a.out
#SBATCH --mem=80G
#SBATCH --array=1
#SBATCH --ntasks-per-node=24
#SBATCH --mail-user=tiffany.tu@duke.edu
#SBATCH --mail-type=END,FAIL

# For LOCO, set array to the chromosome number:
# chr_num=$((SLURM_ARRAY_TASK_ID))
# echo "Running joint gwas"
# #time Rscript saige_step1_quant.R -a "$rep_num" -l 1
# for rep_num in {1..10}; do
#   time Rscript saige_step2_quant.R -a "$rep_num" -l 1 -c "$chr_num"
# done



rep_num=$((SLURM_ARRAY_TASK_ID))
time Rscript saige_step1_quant.R -a "$rep_num" -l 0
time Rscript saige_step2_quant.R -a "$rep_num" -l 0