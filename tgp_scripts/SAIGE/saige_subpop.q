#!/bin/bash
#SBATCH -p ochoalab --account=ochoalab
#SBATCH --job-name=tgp_group2
#SBATCH --output=tgp_%a_group2.out
#SBATCH --array=2-50
#SBATCH --mem=150G
#SBATCH --ntasks-per-node=24
#SBATCH --mail-user=tiffany.tu@duke.edu
#SBATCH --mail-type=END,FAIL

input_value=$((SLURM_ARRAY_TASK_ID))

export LD_LIBRARY_PATH=/opt/apps/rhel8/lapack/lib64:$LD_LIBRARY_PATH
module load R/4.1.1-rhel8

# saige with binary traits

# time Rscript saige_step1.R -a subpop -n $input_value -s amr
# time Rscript saige_step2.R -a subpop -n $input_value -s amr
# 
# time Rscript saige_step1.R -a subpop -n $input_value -s eas
# time Rscript saige_step2.R -a subpop -n $input_value -s eas
# 
# time Rscript saige_step1.R -a subpop -n $input_value -s eur
# time Rscript saige_step2.R -a subpop -n $input_value -s eur
# 
# time Rscript saige_step1.R -a subpop -n $input_value -s sas
# time Rscript saige_step2.R -a subpop -n $input_value -s sas

time Rscript saige_step1.R -a subpop -n $input_value -s group2
time Rscript saige_step2.R -a subpop -n $input_value -s group2

module unload R/4.1.1-rhel8
