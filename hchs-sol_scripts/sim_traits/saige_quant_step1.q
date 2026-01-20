#!/bin/bash

#SBATCH --job-name=s1loco_hchs-sol
#SBATCH --output=s1loco_hchs-sol-%a.out
#SBATCH --account=pro00108518
#SBATCH --mem=80G
#SBATCH --array=1-10
#SBATCH --ntasks-per-node=24
#SBATCH --mail-user=tiffany.tu@duke.edu
#SBATCH --mail-type=END,FAIL


rep_num=$((SLURM_ARRAY_TASK_ID))

# Run R scripts
echo "Running joint gwas"
time Rscript saige_step1_quant.R -a "$rep_num" -l 1




