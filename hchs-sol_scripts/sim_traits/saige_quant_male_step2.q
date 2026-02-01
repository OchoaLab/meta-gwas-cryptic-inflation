#!/bin/bash

#SBATCH --job-name=s2noloco_male
#SBATCH --output=%a_s2noloco_male.out
#SBATCH --account=pro00108518
#SBATCH --mem=75G
#SBATCH --array=1
#SBATCH --ntasks-per-node=24
#SBATCH --mail-user=tiffany.tu@duke.edu
#SBATCH --mail-type=END,FAIL


rep_num=$((SLURM_ARRAY_TASK_ID))
# Run R scripts
echo "Running sex-meta male no LOCO"
time Rscript saige_step2_quant_sex.R -s male -a "$rep_num" -l 0 


echo "Running sex-meta male with LOCO"
# For LOCO, set array to the chromosome number:
# chr_num=$((SLURM_ARRAY_TASK_ID))
# for rep_num in {1..10}; do
#   time Rscript saige_step2_quant_sex.R -s male -a "$rep_num" -l 1 -c "$chr_num"
# done



