#!/bin/bash

#SBATCH --job-name=combine
#SBATCH --output=hchs-sol_loco_results.out
#SBATCH --account=pro00108518
#SBATCH --mem=80G
#SBATCH --ntasks-per-node=24
#SBATCH --mail-user=tiffany.tu@duke.edu
#SBATCH --mail-type=END,FAIL
dir="/home/tt207/pro00108518/hchs-sol/Ia/cryptic-relatedness/sim_traits"


 for i in {1..10}; do
   rep="rep_$i"
   # combine 22 chrom results into one file
   # awk 'FNR==1 && NR!=1 {next} {print}' $dir/$rep/saige_output_simtrait_loco_chr*.txt > $dir/$rep/saige_output_simtrait_loco.txt
   # echo "results of all chromosomes combined into file: $dir/$rep/saige_output_simtrait_loco_1000.txt"
   awk 'FNR==1 && NR!=1 {next} {print}' $dir/$rep/saige_output_simtrait_female_loco_chr*.txt > $dir/$rep/saige_output_female_simtrait_loco.txt
   echo "results of all chromosomes combined into file: $dir/$rep/saige_output_female_simtrait_loco_1000.txt"
   awk 'FNR==1 && NR!=1 {next} {print}' $dir/$rep/saige_output_simtrait_male_loco_chr*.txt > $dir/$rep/saige_output_male_simtrait_loco.txt
   echo "results of all chromosomes combined into file: $dir/$rep/saige_output_male_simtrait_loco_1000.txt"
   
   #rm $dir/$rep/saige_output_simtrait_loco_chr*.*
   #rm $dir/$rep/saige_output_simtrait_female_loco_chr*.*
   #rm $dir/$rep/saige_output_simtrait_male_loco_chr*.*
 done


