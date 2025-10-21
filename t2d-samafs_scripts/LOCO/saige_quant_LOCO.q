#!/bin/bash

#SBATCH --job-name=samafs
#SBATCH --output=samafs_quant_chr%a.out
#SBATCH --mem=80G
#SBATCH --array=1-22
#SBATCH --ntasks-per-node=24
#SBATCH --mail-user=tiffany.tu@duke.edu
#SBATCH --mail-type=END,FAIL

chr_num=$((SLURM_ARRAY_TASK_ID))
dir="/home/tt207/pro00108518/t2d-samafs/study2/exome_chip/cryptic-relatedness/saige_loco"


traits=("height" "LOG_bmi" "LOG_whr" "LOG_waistc" "LOG_cystatin_c" "LOG_a2h_ins" "LOG_creatinine" "LOG_adiponectin" "LOG_leptin" "LOG_tg" "LOG_hipc" "LOG_dbp" "LOG_chol" "LOG_ldl" "LOG_hdl" "LOG_fast_glu" "LOG_fast_ins" "LOG_sbp" "LOG_a2h_glu" "LOG_weight")
trait_age=("HEIGHT_AGE" "BMI_AGE" "WHR_AGE" "WAISTC_AGE" "CYSTATIN_C_AGE" "A2H_INS_AGE" "CREATININE_AGE" "ADIPONECTIN_AGE" "LEPTIN_AGE" "TG_AGE" "HIPC_AGE" "DBP_AGE" "CHOL_AGE" "LDL_AGE" "HDL_AGE" "FAST_GLU_AGE" "FAST_INS_AGE" "SBP_AGE" "A2H_GLU_AGE" "WEIGHT_AGE")


# Loop through the traits and trait_age arrays
for i in "${!traits[@]}"; do
trait=${traits[$i]}
age_trait=${trait_age[$i]}

# Run R scripts for male
echo "Running for joint: $trait and $age_trait"
#time Rscript saige_step1_quant_LOCO.R -t "$trait" -a "$age_trait" 
time Rscript saige_step2_quant_LOCO.R -t "$trait" -a "$age_trait" -c "$chr_num"

done

