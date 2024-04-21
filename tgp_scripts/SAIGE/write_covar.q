#!/bin/bash
#SBATCH -p ochoalab --account=ochoalab
#SBATCH --job-name=write_covar
#SBATCH --output=covar_%a_2.out
#SBATCH --array=1-50
#SBATCH --mem=220G
#SBATCH --ntasks-per-node=24
#SBATCH --mail-user=tiffany.tu@duke.edu
#SBATCH --mail-type=END,FAIL

input_value=$((SLURM_ARRAY_TASK_ID))

module load R/4.1.1-rhel8
time Rscript write_covar_2.R -n $input_value 
module unload R/4.1.1-rhel8
