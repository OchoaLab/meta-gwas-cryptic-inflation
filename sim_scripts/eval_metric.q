#!/bin/bash
#SBATCH -p ochoalab --account=ochoalab
#SBATCH --job-name=eval-quant
#SBATCH --output=eval_quant.out
#SBATCH --mem=80G
#SBATCH --ntasks-per-node=60
#SBATCH --mail-user=tiffany.tu@duke.edu
#SBATCH --mail-type=END,FAIL

input_value=$((SLURM_ARRAY_TASK_ID))

module load R/4.1.1-rhel8
# time Rscript eval_metric_gc_binary.R -s sim1_h08 -f 1G_3000n_100causal_500000m
# time Rscript eval_metric_gc_binary.R -s sim2_h08 -f 30G_3000n_100causal_500000m
# time Rscript eval_metric_gc_binary.R -s sim3_h08 -f 30G_3000n_100causal_500000m
# time Rscript eval_metric_gc_binary.R -s sim4_h08 -f 30G_3000n_100causal_500000m

time Rscript eval_metric_gc_quant.R -s sim1_h08 -f 1G_3000n_100causal_500000m
time Rscript eval_metric_gc_quant.R -s sim2_h08 -f 30G_3000n_100causal_500000m
time Rscript eval_metric_gc_quant.R -s sim3_h08 -f 30G_3000n_100causal_500000m
time Rscript eval_metric_gc_quant.R -s sim4_h08 -f 30G_3000n_100causal_500000m

module load R/4.1.1-rhel8


