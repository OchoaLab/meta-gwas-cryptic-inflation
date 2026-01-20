#!/bin/bash
#SBATCH --job-name=noloco_female
#SBATCH --output=%a_noloco_hchs-sol_female.out
#SBATCH --mem=75G
#SBATCH --array=1
#SBATCH --ntasks-per-node=24
#SBATCH --mail-user=tiffany.tu@duke.edu
#SBATCH --mail-type=END,FAIL

rep_num=$((SLURM_ARRAY_TASK_ID))
# Run R scripts for female
echo "Running for female: $trait and $age_trait"
time Rscript saige_step1_quant_sex.R -s female -a "$rep_num" -l 0
time Rscript saige_step2_quant_sex.R -s female -a "$rep_num" -l 0



