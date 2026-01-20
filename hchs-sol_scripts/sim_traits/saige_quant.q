#!/bin/bash

#SBATCH --job-name=noloco_hchs-sol-saige
#SBATCH --output=noloco_hchs-sol-%a_150.out
#SBATCH --mem=80G
#SBATCH --account=pro00108518
#SBATCH --array=1
#SBATCH --ntasks-per-node=24
#SBATCH --mail-user=tiffany.tu@duke.edu
#SBATCH --mail-type=END,FAIL


rep_num=$((SLURM_ARRAY_TASK_ID))

# Run R scripts
echo "Running joint gwas"
time Rscript saige_step1_quant.R -a "$rep_num" -l 0
time Rscript saige_step2_quant.R -a "$rep_num" -l 0



