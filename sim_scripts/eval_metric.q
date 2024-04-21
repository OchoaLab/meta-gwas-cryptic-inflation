#!/bin/bash
#SBATCH -p ochoalab --account=ochoalab
#SBATCH --job-name=eval-4
#SBATCH --output=eval_4.out
#SBATCH --mem=120G
#SBATCH --ntasks-per-node=60
#SBATCH --mail-user=tiffany.tu@duke.edu
#SBATCH --mail-type=END,FAIL

input_value=$((SLURM_ARRAY_TASK_ID))

module load R/4.1.1-rhel8
#conda activate RSAIGE
time Rscript eval_metric_sim4_subpop.R -s sim4_h08 -f 30G_3000n_100causal_500000m 
#time Rscript eval_metric.R -s sim3_h08 -f 30G_3000n_100causal_500000m 
module load R/4.1.1-rhel8
