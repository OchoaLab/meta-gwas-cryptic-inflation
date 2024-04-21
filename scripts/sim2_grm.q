#!/bin/bash
#SBATCH -p ochoalab --account=ochoalab
#SBATCH --job-name=sim2grm
#SBATCH --array=2,11,19
#SBATCH --output=sim2_grm_%a.out
#SBATCH --mem=120G
#SBATCH --ntasks-per-node=60
#SBATCH --mail-user=tiffany.tu@duke.edu
#SBATCH --mail-type=END,FAIL

input_value=$((SLURM_ARRAY_TASK_ID))

mkdir /hpc/group/ochoalab/tt207/meta_analysis_aim/sim2_h08/rep$input_value/sex
filename='30G_3000n_100causal_500000m'

# split by  sex
module load Plink/1.90

time plink --keep-allele-order --bfile /hpc/group/ochoalab/tt207/meta_analysis_aim/sim2_h08/rep$input_value/${filename} --filter-males --make-bed --out /hpc/group/ochoalab/tt207/meta_analysis_aim/sim2_h08/rep$input_value/sex/${filename}_male
time plink --keep-allele-order --bfile /hpc/group/ochoalab/tt207/meta_analysis_aim/sim2_h08/rep$input_value/${filename} --filter-females --make-bed --out /hpc/group/ochoalab/tt207/meta_analysis_aim/sim2_h08/rep$input_value/sex/${filename}_female


# grm
time gcta --bfile /hpc/group/ochoalab/tt207/meta_analysis_aim/sim2_h08/rep$input_value/${filename} --make-grm --out /hpc/group/ochoalab/tt207/meta_analysis_aim/sim2_h08/rep$input_value/${filename}
time gcta --grm /hpc/group/ochoalab/tt207/meta_analysis_aim/sim2_h08/rep$input_value/${filename} --pca 10 --out /hpc/group/ochoalab/tt207/meta_analysis_aim/sim2_h08/rep$input_value/${filename}

time gcta --bfile /hpc/group/ochoalab/tt207/meta_analysis_aim/sim2_h08/rep$input_value/sex/${filename}_female --make-grm --out /hpc/group/ochoalab/tt207/meta_analysis_aim/sim2_h08/rep$input_value/sex/${filename}_female
time gcta --grm /hpc/group/ochoalab/tt207/meta_analysis_aim/sim2_h08/rep$input_value/sex/${filename}_female --pca 10 --out /hpc/group/ochoalab/tt207/meta_analysis_aim/sim2_h08/rep$input_value/sex/${filename}_female

time gcta --bfile /hpc/group/ochoalab/tt207/meta_analysis_aim/sim2_h08/rep$input_value/sex/${filename}_male --make-grm --out /hpc/group/ochoalab/tt207/meta_analysis_aim/sim2_h08/rep$input_value/sex/${filename}_male
time gcta --grm /hpc/group/ochoalab/tt207/meta_analysis_aim/sim2_h08/rep$input_value/sex/${filename}_male --pca 10 --out /hpc/group/ochoalab/tt207/meta_analysis_aim/sim2_h08/rep$input_value/sex/${filename}_male

time gcta --bfile /hpc/group/ochoalab/tt207/meta_analysis_aim/sim2_h08/rep$input_value/subpop/${filename}_S1 --make-grm --out /hpc/group/ochoalab/tt207/meta_analysis_aim/sim2_h08/rep$input_value/subpop/${filename}_S1
time gcta --grm /hpc/group/ochoalab/tt207/meta_analysis_aim/sim2_h08/rep$input_value/subpop/${filename}_S1 --pca 10 --out /hpc/group/ochoalab/tt207/meta_analysis_aim/sim2_h08/rep$input_value/subpop/${filename}_S1

time gcta --bfile /hpc/group/ochoalab/tt207/meta_analysis_aim/sim2_h08/rep$input_value/subpop/${filename}_S2 --make-grm --out /hpc/group/ochoalab/tt207/meta_analysis_aim/sim2_h08/rep$input_value/subpop/${filename}_S2
time gcta --grm /hpc/group/ochoalab/tt207/meta_analysis_aim/sim2_h08/rep$input_value/subpop/${filename}_S2 --pca 10 --out /hpc/group/ochoalab/tt207/meta_analysis_aim/sim2_h08/rep$input_value/subpop/${filename}_S2

time gcta --bfile /hpc/group/ochoalab/tt207/meta_analysis_aim/sim2_h08/rep$input_value/subpop/${filename}_S3 --make-grm --out /hpc/group/ochoalab/tt207/meta_analysis_aim/sim2_h08/rep$input_value/subpop/${filename}_S3
time gcta --grm /hpc/group/ochoalab/tt207/meta_analysis_aim/sim2_h08/rep$input_value/subpop/${filename}_S3 --pca 10 --out /hpc/group/ochoalab/tt207/meta_analysis_aim/sim2_h08/rep$input_value/subpop/${filename}_S3



module unload Plink/1.90
# # # 
