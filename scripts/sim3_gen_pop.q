#!/bin/bash
#SBATCH -p ochoalab --account=ochoalab
#SBATCH --job-name=sim3
#SBATCH --output=sim3_%a.out
#SBATCH --array=1-20
#SBATCH --mem=140G
#SBATCH --ntasks-per-node=60
#SBATCH --mail-user=tiffany.tu@duke.edu
#SBATCH --mail-type=END,FAIL

input_value=$((SLURM_ARRAY_TASK_ID))
module load R/4.1.1-rhel8
time Rscript sim3_step1.R -n $input_value
echo "finished step1"
time Rscript sim3_step2.R -n $input_value
echo "finished step2"
time Rscript sim3_step3.R -n $input_value
echo "finished step3"
module unload R/4.1.1-rhel8

