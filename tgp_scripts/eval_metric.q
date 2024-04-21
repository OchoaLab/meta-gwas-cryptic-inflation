#!/bin/bash
#SBATCH -p ochoalab --account=ochoalab
#SBATCH --job-name=eval_tgp
#SBATCH --array=1-50
#SBATCH --output=eval_%a_study.out
#SBATCH --mem=160G
#SBATCH --ntasks-per-node=60
#SBATCH --mail-user=tiffany.tu@duke.edu
#SBATCH --mail-type=END,FAIL

input_value=$((SLURM_ARRAY_TASK_ID))

module load R/4.1.1-rhel8
#conda activate RSAIGE
#time Rscript eval_metric.R -r $input_value
time Rscript eval_metric_study.R -r $input_value

module load R/4.1.1-rhel8
