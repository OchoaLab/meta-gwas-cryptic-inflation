#!/bin/bash

#SBATCH --job-name=noloco_hchs-sol-saige
#SBATCH --output=noloco_hchs-sol-%a.out
#SBATCH --mem=80G
#SBATCH --account=pro00108518
#SBATCH --array=1-10
#SBATCH --ntasks-per-node=24
#SBATCH --mail-user=tiffany.tu@duke.edu
#SBATCH --mail-type=END,FAIL


rep_num=$((SLURM_ARRAY_TASK_ID))

# Run R scripts
echo "Running joint gwas no LOCO"
time Rscript saige_step1_quant.R -a "$rep_num" -l 0
time Rscript saige_step2_quant.R -a "$rep_num" -l 0

## # For LOCO, set array to the chromosome number:
# echo "Running joint gwas no LOCO"
# time Rscript saige_step1_quant.R -a "$rep_num" -l 1

# chr_num=$((SLURM_ARRAY_TASK_ID))
# for rep_num in {1..10}; do
#   time Rscript saige_step2_quant.R -a "$rep_num" -l 1 -c "$chr_num"
# done

