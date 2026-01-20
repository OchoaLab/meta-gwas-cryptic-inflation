#!/bin/bash

#SBATCH --job-name=s2loco_hchs-sol
#SBATCH --output=s2loco_hchs-sol-%a.out
#SBATCH --account=pro00108518
#SBATCH --mem=20G
#SBATCH --array=1-22
#SBATCH --ntasks-per-node=24
#SBATCH --mail-user=tiffany.tu@duke.edu
#SBATCH --mail-type=END,FAIL


chr_num=$((SLURM_ARRAY_TASK_ID))

# Run R scripts
echo "Running joint gwas"
#time Rscript saige_step1_quant.R -a "$rep_num" -l 1
for rep_num in {1..10}; do
  time Rscript saige_step2_quant.R -a "$rep_num" -l 1 -c "$chr_num"
done

