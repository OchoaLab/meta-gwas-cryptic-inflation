#!/bin/bash

#SBATCH --job-name=combine
#SBATCH --output=samafs_loco_results.out
#SBATCH --mem=80G
#SBATCH --ntasks-per-node=24
#SBATCH --mail-user=tiffany.tu@duke.edu
#SBATCH --mail-type=END,FAIL
dir="/home/tt207/pro00108518/t2d-samafs/study2/exome_chip/cryptic-relatedness/saige_loco"

traits=("height" "LOG_bmi" "LOG_whr" "LOG_waistc" "LOG_cystatin_c" "LOG_a2h_ins" "LOG_creatinine" "LOG_adiponectin" "LOG_leptin" "LOG_tg" "LOG_hipc" "LOG_dbp" "LOG_chol" "LOG_ldl" "LOG_hdl" "LOG_fast_glu" "LOG_fast_ins" "LOG_sbp" "LOG_a2h_glu" "LOG_weight")
# 
# for i in "${!traits[@]}"; do
# trait=${traits[$i]}
# 
#   # combine 22 chrom results into one file
#   awk 'FNR==1 && NR!=1 {next} {print}' $dir/saige_output_${trait}_trait_age_loco_chr*.txt > $dir/saige_output_${trait}_loco.txt
#   echo "results of all chromosomes combined into file: $dir/saige_output_${trait}_loco.txt"
#   rm $dir/saige_output_${trait}_trait_age_loco_chr*.*
# done


# combine 22 chrom results into one file
# awk 'FNR==1 && NR!=1 {next} {print}' $dir/saige_output_t2d_t2d_age_loco_chr*.txt > $dir/saige_output_t2d_loco.txt
# echo "results of all chromosomes combined into file: $dir/saige_output_${trait}_loco.txt"
# rm $dir/saige_output_t2d_t2d_age_loco_chr*.*

###########################################################################################
# sex stratified
awk 'FNR==1 && NR!=1 {next} {print}' $dir/sex/saige_output_t2d_binary_male_t2d_age_loco_chr*.txt > $dir/sex/saige_output_t2d_male_loco.txt
echo "results of all chromosomes combined into file: $dir/saige_output_${trait}_loco.txt"
rm $dir/sex/saige_output_t2d_binary_male_t2d_age_loco_chr*.*
awk 'FNR==1 && NR!=1 {next} {print}' $dir/sex/saige_output_t2d_binary_female_t2d_age_loco_chr*.txt > $dir/sex/saige_output_t2d_female_loco.txt
echo "results of all chromosomes combined into file: $dir/saige_output_${trait}_loco.txt"
rm $dir/sex/saige_output_t2d_binary_female_t2d_age_loco_chr*.*
  
for i in "${!traits[@]}"; do
trait=${traits[$i]}
  # combine 22 chrom results into one file
  awk 'FNR==1 && NR!=1 {next} {print}' $dir/sex/saige_output_${trait}_female_trait_age_loco_chr*.txt > $dir/sex/saige_output_female_${trait}_loco.txt
  echo "results of all chromosomes combined into file: $dir/saige_output_female_${trait}_loco.txt"
  rm $dir/sex/saige_output_${trait}_female_trait_age_loco_chr*.*
  
  awk 'FNR==1 && NR!=1 {next} {print}' $dir/sex/saige_output_${trait}_male_trait_age_loco_chr*.txt > $dir/sex/saige_output_male_${trait}_loco.txt
  echo "results of all chromosomes combined into file: $dir/saige_output_male_${trait}_loco.txt"
  rm $dir/sex/saige_output_${trait}_male_trait_age_loco_chr*.*
done
  
