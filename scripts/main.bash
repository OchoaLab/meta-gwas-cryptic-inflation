
# make link to existing data from pca-assoc project
# use 20-generation admixed family, first replicate!
ORIG=../../../pca-assoc-paper/data/sim-n1000-k10-f0.1-s0.5-g20/rep-1
cd ../data/
mkdir rep-1
cd rep-1
ln -s $ORIG/data.bed data.bed
ln -s $ORIG/data.bim data.bim
ln -s $ORIG/data.fam data.fam
ln -s $ORIG/data.phen data.phen

# use plink to filter the raw data
cd ../data/rep-1/
# separate males and females
# --pheno add phenotype data from .phen file to output, but does not create new phen files
plink2 --bfile data --pheno data.phen --keep-males --make-bed --out males
plink2 --bfile data --pheno data.phen --keep-females --make-bed --out females

# creates *.phen file from each *.fam file
Rscript ../../scripts/fam_to_phen.R males
Rscript ../../scripts/fam_to_phen.R females
