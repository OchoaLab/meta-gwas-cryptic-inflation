#!/bin/bash
#SBATCH -p ochoalab --account=ochoalab
#SBATCH --job-name=tgp_saige
#SBATCH --output=saige_tgp_%a.out
#SBATCH --array=1-50
#SBATCH --mem=180G
#SBATCH --ntasks-per-node=24
#SBATCH --mail-user=tiffany.tu@duke.edu
#SBATCH --mail-type=END,FAIL

input_value=$((SLURM_ARRAY_TASK_ID))

export LD_LIBRARY_PATH=/opt/apps/rhel8/lapack/lib64:$LD_LIBRARY_PATH
module load R/4.1.1-rhel8

# saige with binary traits
# time Rscript saige_step1.R -a all -n $input_value -s all
# time Rscript saige_step2.R -a all -n $input_value -s all

time Rscript saige_step1.R -a sex -n $input_value -s male
time Rscript saige_step2.R -a sex -n $input_value -s male

# time Rscript saige_step1.R -a sex -n $input_value -s female
# time Rscript saige_step2.R -a sex -n $input_value -s female


module unload R/4.1.1-rhel8
