#!/bin/bash
#SBATCH -p ochoalab --account=ochoalab
#SBATCH --job-name=sim4
#SBATCH --array=2-20
#SBATCH --output=sim4_%a.out
#SBATCH --mem=120G
#SBATCH --ntasks-per-node=60
#SBATCH --mail-user=tiffany.tu@duke.edu
#SBATCH --mail-type=END,FAIL

input_value=$((SLURM_ARRAY_TASK_ID))

module load R/4.1.1-rhel8
time Rscript sim4_step1.R -n $input_value
echo "finished step1"
time Rscript sim4_step2.R -n $input_value
echo "finished step2"
time Rscript sim4_step3.R -n $input_value
echo "finished step3"
time Rscript sim4_step4.R -n $input_value
echo "finished step4"
module unload R/4.1.1-rhel8

