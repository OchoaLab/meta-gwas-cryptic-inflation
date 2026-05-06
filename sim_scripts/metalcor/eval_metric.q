#!/bin/bash

#SBATCH --job-name=eval-metacorr
#SBATCH --output=eval_metacorr_%a.out
#SBATCH --mem=40G
#SBATCH --ntasks-per-node=60
#SBATCH --mail-user=tiffany.tu@duke.edu
#SBATCH --mail-type=END,FAIL

# Usage: sbatch --array=1-16 eval_metric.q
# Array 1-16: 4 sims x 4 (trait+method) combos
# SIM:   1=sim1, 2=sim2, 3=sim3, 4=sim4
# COMBO: 1=binary+median, 2=binary+mean, 3=quant+median, 4=quant+mean

SIM_IDX=$(( (SLURM_ARRAY_TASK_ID - 1) % 4 + 1 ))
COMBO=$(( (SLURM_ARRAY_TASK_ID - 1) / 4 + 1 ))

case "$SIM_IDX" in
  1) SIM="sim1_h08"; FILE="1G_3000n_100causal_500000m" ;;
  2) SIM="sim2_h08"; FILE="30G_3000n_100causal_500000m" ;;
  3) SIM="sim3_h08"; FILE="30G_3000n_100causal_500000m" ;;
  4) SIM="sim4_h08"; FILE="30G_3000n_100causal_500000m" ;;
esac

case "$COMBO" in
  1) TRAIT="binary";  MEDIAN="TRUE"  ;;
  2) TRAIT="binary";  MEDIAN="FALSE" ;;
  3) TRAIT="quant";   MEDIAN="TRUE"  ;;
  4) TRAIT="quant";   MEDIAN="FALSE" ;;
esac

module load R/4.1.1-rhel8

# Sex-stratified
time Rscript eval_metric_metacorr_${TRAIT}.R -s $SIM -f $FILE -m $MEDIAN

# Subpop-stratified
time Rscript eval_metric_metacorr_subpop_${TRAIT}.R -s $SIM -f $FILE -m $MEDIAN
