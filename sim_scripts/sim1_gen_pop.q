#!/bin/bash
#SBATCH -p ochoalab --account=ochoalab
#SBATCH --job-name=sim1
#SBATCH --output=sim1_%a.out
#SBATCH --array=18
#SBATCH --mem=240G
#SBATCH --ntasks-per-node=60
#SBATCH --mail-user=tiffany.tu@duke.edu
#SBATCH --mail-type=END,FAIL

# generate data for 10 replicates
input_value=$((SLURM_ARRAY_TASK_ID))
filename='1G_3000n_100causal_500000m'

module load R/4.1.1-rhel8
time Rscript sim1_gen_pop.R -n $input_value
module unload R/4.1.1-rhel8

# split data by subpop and by sex 
module load Plink/1.90
time plink --keep-allele-order --bfile /hpc/group/ochoalab/tt207/meta_analysis_aim/sim1_h08/rep$input_value/${filename} --keep-fam S1.txt --make-bed --out /hpc/group/ochoalab/tt207/meta_analysis_aim/sim1_h08/rep$input_value/subpop/${filename}_S1
time plink --keep-allele-order --bfile /hpc/group/ochoalab/tt207/meta_analysis_aim/sim1_h08/rep$input_value/${filename} --keep-fam S2.txt --make-bed --out /hpc/group/ochoalab/tt207/meta_analysis_aim/sim1_h08/rep$input_value/subpop/${filename}_S2
time plink --keep-allele-order --bfile /hpc/group/ochoalab/tt207/meta_analysis_aim/sim1_h08/rep$input_value/${filename} --keep-fam S3.txt --make-bed --out /hpc/group/ochoalab/tt207/meta_analysis_aim/sim1_h08/rep$input_value/subpop/${filename}_S3

time plink --keep-allele-order --bfile /hpc/group/ochoalab/tt207/meta_analysis_aim/sim1_h08/rep$input_value/${filename} --filter-males --make-bed --out /hpc/group/ochoalab/tt207/meta_analysis_aim/sim1_h08/rep$input_value/sex/${filename}_male
time plink --keep-allele-order --bfile /hpc/group/ochoalab/tt207/meta_analysis_aim/sim1_h08/rep$input_value/${filename} --filter-females --make-bed --out /hpc/group/ochoalab/tt207/meta_analysis_aim/sim1_h08/rep$input_value/sex/${filename}_female

# run grm
time gcta --bfile /hpc/group/ochoalab/tt207/meta_analysis_aim/sim1_h08/rep$input_value/subpop/${filename}_S1 --make-grm --out /hpc/group/ochoalab/tt207/meta_analysis_aim/sim1_h08/rep$input_value/subpop/${filename}_S1
time gcta --grm /hpc/group/ochoalab/tt207/meta_analysis_aim/sim1_h08/rep$input_value/subpop/${filename}_S1 --pca 10 --out /hpc/group/ochoalab/tt207/meta_analysis_aim/sim1_h08/rep$input_value/subpop/${filename}_S1
# 
time gcta --bfile /hpc/group/ochoalab/tt207/meta_analysis_aim/sim1_h08/rep$input_value/subpop/${filename}_S2 --make-grm --out /hpc/group/ochoalab/tt207/meta_analysis_aim/sim1_h08/rep$input_value/subpop/${filename}_S2
time gcta --grm /hpc/group/ochoalab/tt207/meta_analysis_aim/sim1_h08/rep$input_value/subpop/${filename}_S2 --pca 10 --out /hpc/group/ochoalab/tt207/meta_analysis_aim/sim1_h08/rep$input_value/subpop/${filename}_S2
# 
time gcta --bfile /hpc/group/ochoalab/tt207/meta_analysis_aim/sim1_h08/rep$input_value/subpop/${filename}_S3 --make-grm --out /hpc/group/ochoalab/tt207/meta_analysis_aim/sim1_h08/rep$input_value/subpop/${filename}_S3
time gcta --grm /hpc/group/ochoalab/tt207/meta_analysis_aim/sim1_h08/rep$input_value/subpop/${filename}_S3 --pca 10 --out /hpc/group/ochoalab/tt207/meta_analysis_aim/sim1_h08/rep$input_value/subpop/${filename}_S3

time gcta --bfile /hpc/group/ochoalab/tt207/meta_analysis_aim/sim1_h08/rep$input_value/${filename} --make-grm --out /hpc/group/ochoalab/tt207/meta_analysis_aim/sim1_h08/rep$input_value/${filename}
time gcta --grm /hpc/group/ochoalab/tt207/meta_analysis_aim/sim1_h08/rep$input_value/${filename} --pca 10 --out /hpc/group/ochoalab/tt207/meta_analysis_aim/sim1_h08/rep$input_value/${filename}

time gcta --bfile /hpc/group/ochoalab/tt207/meta_analysis_aim/sim1_h08/rep$input_value/sex/${filename}_female --make-grm --out /hpc/group/ochoalab/tt207/meta_analysis_aim/sim1_h08/rep$input_value/sex/${filename}_female
time gcta --grm /hpc/group/ochoalab/tt207/meta_analysis_aim/sim1_h08/rep$input_value/sex/${filename}_female --pca 10 --out /hpc/group/ochoalab/tt207/meta_analysis_aim/sim1_h08/rep$input_value/sex/${filename}_female

time gcta --bfile /hpc/group/ochoalab/tt207/meta_analysis_aim/sim1_h08/rep$input_value/sex/${filename}_male --make-grm --out /hpc/group/ochoalab/tt207/meta_analysis_aim/sim1_h08/rep$input_value/sex/${filename}_male
time gcta --grm /hpc/group/ochoalab/tt207/meta_analysis_aim/sim1_h08/rep$input_value/sex/${filename}_male --pca 10 --out /hpc/group/ochoalab/tt207/meta_analysis_aim/sim1_h08/rep$input_value/sex/${filename}_male

module unload Plink/1.90

