#!/bin/bash

#SBATCH --job-name=s2noloco_female
#SBATCH --output=%a_s2noloco_female_150.out
#SBATCH --account=pro00108518
#SBATCH --mem=75G
#SBATCH --array=1
#SBATCH --ntasks-per-node=24
#SBATCH --mail-user=tiffany.tu@duke.edu
#SBATCH --mail-type=END,FAIL

#chr_num=$((SLURM_ARRAY_TASK_ID))
rep_num=$((SLURM_ARRAY_TASK_ID))
# Run R scripts
echo "Running joint gwas"
time Rscript saige_step2_quant_sex.R -s female -a "$rep_num" -l 0 -c "$chr_num"
# for rep_num in {1..10}; do
#   time Rscript saige_step2_quant_sex.R -s female -a "$rep_num" -l 1 -c "$chr_num"
# done





