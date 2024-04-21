#!/bin/bash
#SBATCH -p ochoalab --account=ochoalab
#SBATCH --job-name=write_covar
#SBATCH --output=covar_%a.out
#SBATCH --array=1-10
#SBATCH --mem=220G
#SBATCH --ntasks-per-node=24
#SBATCH --mail-user=tiffany.tu@duke.edu
#SBATCH --mail-type=END,FAIL

input_value=$((SLURM_ARRAY_TASK_ID))

module load R/4.1.1-rhel8
time Rscript write_covar.R -n $input_value -s 4
module unload R/4.1.1-rhel8
