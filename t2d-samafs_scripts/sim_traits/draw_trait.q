#!/bin/bash

#SBATCH --job-name=%a_trait_sim
#SBATCH --output=trait_sim_%a.out
#SBATCH --array=1-10
#SBATCH --mem=100G
#SBATCH --ntasks-per-node=24
#SBATCH --mail-user=tiffany.tu@duke.edu
#SBATCH --mail-type=END,FAIL


rep_num=$((SLURM_ARRAY_TASK_ID))
mkdir rep_${rep_num}

# draws trait and write covar file for saige
echo "rep number: $rep_num"
time Rscript draw_trait.R -a "$rep_num"


