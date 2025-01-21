#!/bin/bash
#SBATCH -p ochoalab --account=ochoalab
#SBATCH --job-name=subset
#SBATCH --output=subset.out
#SBATCH --mem=80G
#SBATCH --ntasks-per-node=1
#SBATCH --mail-user=tiffany.tu@duke.edu
#SBATCH --mail-type=END,FAIL

# NOTE: 32G sufficed for HO and HGDP, but increased for TGP

module load Plink/1.90

# make directory for data subset

time plink --keep-allele-order --bfile /hpc/group/ochoalab/zh105/project2/hchs-sol/Ia/data_qc --keep ids_male.txt --make-bed --out /hpc/group/ochoalab/tt207/meta_analysis_aim/hchs-sol/sex/data_qc_male
time plink --keep-allele-order --bfile /hpc/group/ochoalab/zh105/project2/hchs-sol/Ia/data_qc --keep ids_female.txt --make-bed --out /hpc/group/ochoalab/tt207/meta_analysis_aim/hchs-sol/sex/data_qc_female


module unload Plink/1.90