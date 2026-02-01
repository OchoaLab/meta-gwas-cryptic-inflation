#!/bin/bash
#SBATCH --job-name=11s2_hchs-sol_female
#SBATCH --output=11s2_hchs-sol_female-chr%a.out
#SBATCH --account=pro00108518
#SBATCH --mem=5G
#SBATCH --array=1-22
#SBATCH --ntasks-per-node=1
#SBATCH --mail-user=tiffany.tu@duke.edu
#SBATCH --mail-type=END,FAIL
chr_num=$((SLURM_ARRAY_TASK_ID))
#traits=("LABA2" "LOG_LABA75" "LOG_SLPA54" "LOG_ANTA4" "LOG_LABA66" "LOG_BMI" "LOG_LABA68" "LOG_LABA69" "LOG_ANTA10A" "LOG_ANTA10B" "LOG_SBPA5" "LOG_SBPA6" "LOG_INSULIN_FAST" "HEIGHT" "LOG_WAIST_HIP" "LOG_LABA70" "LOG_LABA76" "LOG_LABA67" "LOG_LABA101" "LOG_LABA91" "LOG_INSULIN_OGTT" "LOG_LABA1" "LABA10" "LABA11" "LABA12" "LABA13" "LABA14" "LOG_LABA3" "LOG_LABA9" "LOG_LABA74" "LOG_LABA102" "LOG_LABA103" "LOG_LABA82")
#1
#traits=("LABA2" "LOG_LABA75" "LOG_SLPA54") 
#2
#traits=("LOG_ANTA4" "LOG_LABA66" "LOG_BMI") 
#3
#traits=("LOG_LABA68" "LOG_LABA69" "LOG_ANTA10A")
#4
#traits=("LOG_ANTA10B" "LOG_SBPA5" "LOG_SBPA6")
#5
#traits=("LOG_INSULIN_FAST" "HEIGHT" "LOG_WAIST_HIP")
#6
#traits=("LOG_LABA70" "LOG_LABA76" "LOG_LABA67")
#7
#traits=( "LOG_LABA101" "LOG_LABA91" "LOG_INSULIN_OGTT")
#8
#traits=("LOG_LABA1" "LABA10" "LABA11")
#9
#traits=("LABA12" "LABA13" "LABA14")
#10
#traits=("LOG_LABA3" "LOG_LABA9" "LOG_LABA74")
#11
traits=("LOG_LABA102" "LOG_LABA103" "LOG_LABA82")
# Loop through the traits and trait_age arrays

for i in "${!traits[@]}"; do
  trait=${traits[$i]}
  # Run R scripts for female
  echo "Running SAIGE STEP2 female: $trait and $age_trait"
  time Rscript saige_step2_quant_sex_LOCO.R -s female -t "$trait" -c "$chr_num"
done


