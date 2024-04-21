#!/bin/bash
#SBATCH -p ochoalab --account=ochoalab
#SBATCH --job-name=sim4_split
#SBATCH --output=sim4_split_%a.out
#SBATCH --array=1-20
#SBATCH --mem=240G
#SBATCH --ntasks-per-node=60
#SBATCH --mail-user=tiffany.tu@duke.edu
#SBATCH --mail-type=END,FAIL

# generate data for 10 replicates
input_value=$((SLURM_ARRAY_TASK_ID))
filename='30G_3000n_100causal_500000m'
main_directory="/hpc/group/ochoalab/tt207/meta_analysis_aim/sim4_h08"

#mkdir ${main_directory}/rep$input_value/subpop

# split data by subpop and by sex 
module load Plink/1.90
time plink --keep-allele-order --bfile ${main_directory}/rep$input_value/${filename} --keep S1-1.txt --make-bed --out ${main_directory}/rep$input_value/subpop/${filename}_S1
time plink --keep-allele-order --bfile ${main_directory}/rep$input_value/${filename} --keep S1-2.txt --make-bed --out ${main_directory}/rep$input_value/subpop/${filename}_S2
time plink --keep-allele-order --bfile ${main_directory}/rep$input_value/${filename} --keep S1-3.txt --make-bed --out ${main_directory}/rep$input_value/subpop/${filename}_S3

# run grm
time gcta --bfile ${main_directory}/rep$input_value/subpop/${filename}_S1 --make-grm --out ${main_directory}/rep$input_value/subpop/${filename}_S1
time gcta --grm ${main_directory}/rep$input_value/subpop/${filename}_S1 --pca 10 --out ${main_directory}/rep$input_value/subpop/${filename}_S1
# 
time gcta --bfile ${main_directory}/rep$input_value/subpop/${filename}_S2 --make-grm --out ${main_directory}/rep$input_value/subpop/${filename}_S2
time gcta --grm ${main_directory}/rep$input_value/subpop/${filename}_S2 --pca 10 --out ${main_directory}/rep$input_value/subpop/${filename}_S2
# 
time gcta --bfile ${main_directory}/rep$input_value/subpop/${filename}_S3 --make-grm --out ${main_directory}/rep$input_value/subpop/${filename}_S3
time gcta --grm ${main_directory}/rep$input_value/subpop/${filename}_S3 --pca 10 --out ${main_directory}/rep$input_value/subpop/${filename}_S3

module unload Plink/1.90


