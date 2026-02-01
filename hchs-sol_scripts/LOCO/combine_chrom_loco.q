#!/bin/bash

#SBATCH --job-name=combine
#SBATCH --account=pro00108518
#SBATCH --output=hchs-sol_loco_results.out
#SBATCH --mem=50G
#SBATCH --ntasks-per-node=24
#SBATCH --mail-user=tiffany.tu@duke.edu
#SBATCH --mail-type=END,FAIL
dir="/home/tt207/pro00108518/hchs-sol/Ia/cryptic-relatedness/saige_loco"

traits=("HEIGHT" "LABA2" "LOG_LABA75" "LOG_SLPA54" "LOG_ANTA4" "LOG_LABA66" "LOG_BMI" "LOG_LABA68" "LOG_LABA69" "LOG_ANTA10A" "LOG_ANTA10B" "LOG_SBPA5" "LOG_SBPA6" "LOG_INSULIN_FAST" "LOG_WAIST_HIP" "LOG_LABA70" "LOG_LABA76" "LOG_LABA67" "LOG_LABA101" "LOG_LABA91" "LOG_INSULIN_OGTT" "LOG_LABA1" "LABA10" "LABA11" "LABA12" "LABA13" "LABA14" "LOG_LABA3" "LOG_LABA9" "LOG_LABA74" "LOG_LABA102" "LOG_LABA103" "LOG_LABA82") 
#traits="HEIGHT"
for i in "${!traits[@]}"; do
  trait=${traits[$i]}

  # combine 22 chrom results into one file
  awk 'FNR==1 && NR!=1 {next} {print}' $dir/saige_output_${trait}_loco_chr*.txt > $dir/saige_output_${trait}_loco.txt
  echo "results of all chromosomes combined into file: $dir/saige_output_${trait}_loco.txt"
  #rm $dir/saige_output_${trait}_loco_chr*.*
done



###########################################################################################
# sex stratified

for i in "${!traits[@]}"; do
trait=${traits[$i]}
  # combine 22 chrom results into one file
  awk 'FNR==1 && NR!=1 {next} {print}' $dir/sex/saige_output_${trait}_female_loco_chr*.txt > $dir/sex/saige_output_female_${trait}_loco.txt
  echo "results of all chromosomes combined into file: $dir/saige_output_female_${trait}_loco.txt"
  #rm $dir/sex/saige_output_${trait}_female_loco_chr*.*

  awk 'FNR==1 && NR!=1 {next} {print}' $dir/sex/saige_output_${trait}_male_loco_chr*.txt > $dir/sex/saige_output_male_${trait}_loco.txt
  echo "results of all chromosomes combined into file: $dir/saige_output_male_${trait}_loco.txt"
  #rm $dir/sex/saige_output_${trait}_male_loco_chr*.*
done

