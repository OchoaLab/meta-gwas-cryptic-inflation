#!/bin/bash
#SBATCH -p ochoalab --account=ochoalab
#SBATCH --job-name=sim4
#SBATCH --array=1-20
#SBATCH --output=sim4_grm_%a.out
#SBATCH --mem=120G
#SBATCH --ntasks-per-node=60
#SBATCH --mail-user=tiffany.tu@duke.edu
#SBATCH --mail-type=END,FAIL

input_value=$((SLURM_ARRAY_TASK_ID))
filename='30G_3000n_100causal_500000m'

# split by and sex
module load Plink/1.90

time plink --keep-allele-order --bfile /hpc/group/ochoalab/tt207/meta_analysis_aim/sim4_h08/rep$input_value/${filename} --filter-males --make-bed --out /hpc/group/ochoalab/tt207/meta_analysis_aim/sim4_h08/rep$input_value/sex/${filename}_male
time plink --keep-allele-order --bfile /hpc/group/ochoalab/tt207/meta_analysis_aim/sim4_h08/rep$input_value/${filename} --filter-females --make-bed --out /hpc/group/ochoalab/tt207/meta_analysis_aim/sim4_h08/rep$input_value/sex/${filename}_female
 
# grm
time gcta --bfile /hpc/group/ochoalab/tt207/meta_analysis_aim/sim4_h08/rep$input_value/${filename} --make-grm --out /hpc/group/ochoalab/tt207/meta_analysis_aim/sim4_h08/rep$input_value/${filename}
time gcta --grm /hpc/group/ochoalab/tt207/meta_analysis_aim/sim4_h08/rep$input_value/${filename} --pca 10 --out /hpc/group/ochoalab/tt207/meta_analysis_aim/sim4_h08/rep$input_value/${filename}

time gcta --bfile /hpc/group/ochoalab/tt207/meta_analysis_aim/sim4_h08/rep$input_value/sex/${filename}_female --make-grm --out /hpc/group/ochoalab/tt207/meta_analysis_aim/sim4_h08/rep$input_value/sex/${filename}_female
time gcta --grm /hpc/group/ochoalab/tt207/meta_analysis_aim/sim4_h08/rep$input_value/sex/${filename}_female --pca 10 --out /hpc/group/ochoalab/tt207/meta_analysis_aim/sim4_h08/rep$input_value/sex/${filename}_female

time gcta --bfile /hpc/group/ochoalab/tt207/meta_analysis_aim/sim4_h08/rep$input_value/sex/${filename}_male --make-grm --out /hpc/group/ochoalab/tt207/meta_analysis_aim/sim4_h08/rep$input_value/sex/${filename}_male
time gcta --grm /hpc/group/ochoalab/tt207/meta_analysis_aim/sim4_h08/rep$input_value/sex/${filename}_male --pca 10 --out /hpc/group/ochoalab/tt207/meta_analysis_aim/sim4_h08/rep$input_value/sex/${filename}_male


module unload Plink/1.90
# # # 
