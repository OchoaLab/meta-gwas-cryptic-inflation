#!/bin/bash
#SBATCH -p ochoalab --account=ochoalab
#SBATCH --job-name=samafs_saige_age
#SBATCH --output=samafs_quant_age.out
#SBATCH --mem=100G
#SBATCH --ntasks-per-node=24
#SBATCH --mail-user=tiffany.tu@duke.edu
#SBATCH --mail-type=END,FAIL

input_value=$((SLURM_ARRAY_TASK_ID))

export LD_LIBRARY_PATH=/opt/apps/rhel8/lapack/lib64:$LD_LIBRARY_PATH
module load R/4.1.1-rhel8

#traits=("cystatin_c" "a2h_ins" "creatinine" "adiponectin" "leptin" "chol" "ldl" "hdl" "tg" "bmi" "hipc" "waistc" "whr" "dbp")
#trait_age=("CYSTATIN_C_AGE" "A2H_INS_AGE" "CREATININE_AGE" "ADIPONECTIN_AGE" "LEPTIN_AGE" "CHOL_AGE" "LDL_AGE" "HDL_AGE" "TG_AGE" "BMI_AGE" "HIPC_AGE" "WAISTC_AGE" "WHR_AGE" "DBP_AGE")

#traits="weight"
#trait_age="WEIGHT_AGE"

# invNormalize two traits
traits=("cystatin_c" "whr")
trait_age=("CYSTATIN_C_AGE" "WHR_AGE")

# Loop through the traits and trait_age arrays
for i in "${!traits[@]}"; do
trait=${traits[$i]}
age_trait=${trait_age[$i]}

# Run R scripts for male
echo "Running for male: $trait and $age_trait"
time Rscript saige_step1_quant.R -t "$trait" -a "$age_trait"
time Rscript saige_step2_quant.R -t "$trait" -a "$age_trait"

done

module unload R/4.1.1-rhel8
