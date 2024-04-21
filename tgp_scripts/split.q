#!/bin/bash
#SBATCH -p ochoalab --account=ochoalab
#SBATCH --job-name=split_ancestry
#SBATCH --output=split.out
#SBATCH --mem=240G
#SBATCH --ntasks-per-node=60
#SBATCH --mail-user=tiffany.tu@duke.edu
#SBATCH --mail-type=END,FAIL

# split data by subpop and by sex 
module load Plink/1.90

# time plink --keep-allele-order --bfile data --filter-males --make-bed --out data_male
# time plink --keep-allele-order --bfile data --filter-females --make-bed --out data_female
# 
# time gcta --bfile data_female --make-grm --out data_female
# time gcta --grm data_female --pca 10 --out data_female
# 
# time gcta --bfile data_male --make-grm --out data_male
# time gcta --grm data_male --pca 10 --out data_male


# by major ancestry:
# time plink --keep-allele-order --bfile data --keep-fam afr_id.txt --make-bed --out data_afr
# time plink --keep-allele-order --bfile data --keep-fam sas_id.txt --make-bed --out data_sas
# time plink --keep-allele-order --bfile data --keep-fam eur_id.txt --make-bed --out data_eur
# time plink --keep-allele-order --bfile data --keep-fam eas_id.txt --make-bed --out data_eas
# time plink --keep-allele-order --bfile data --keep-fam amr_id.txt --make-bed --out data_amr
# 
# time gcta --bfile data_afr --make-grm --out data_afr
# time gcta --grm data_afr --pca 10 --out data_afr
# 
# time gcta --bfile data_sas --make-grm --out data_sas
# time gcta --grm data_sas --pca 10 --out data_sas
# 
# time gcta --bfile data_eur --make-grm --out data_eur
# time gcta --grm data_eur --pca 10 --out data_eur
# 
# time gcta --bfile data_eas --make-grm --out data_eas
# time gcta --grm data_eas --pca 10 --out data_eas
# 
# time gcta --bfile data_amr --make-grm --out data_amr
# time gcta --grm data_amr --pca 10 --out data_amr

# by group1 and group2
time plink --keep-allele-order --bfile data --keep-fam group1_id.txt --make-bed --out data_group1
time plink --keep-allele-order --bfile data --keep-fam group2_id.txt --make-bed --out data_group2
time gcta --bfile data_group1 --make-grm --out data_group1
time gcta --grm data_group1 --pca 10 --out data_group1
time gcta --bfile data_group2 --make-grm --out data_group2
time gcta --grm data_group2 --pca 10 --out data_group2

module unload Plink/1.90

