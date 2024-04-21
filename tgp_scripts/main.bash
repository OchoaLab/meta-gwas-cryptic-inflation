# TGP data with 50 replicate of simulated traits
# first calcualte PCs of main 'data', then split data by ancestry and caluclate PCs: pcs.q, split.q
## added additional analysis of group 1 (AFR & SAS) and group 2 (AMR, EAS, EUR) study-meta analysis -- also split data and caluclate PCs with split.q

# Next is to write SAIGE covar files and save that into each replicate folder. 

# Move into SAIGE folder, run write_covar.q
# Once covar files are available, run saige.q and saige_subpop.q

# METAL folder for meta-analyses

mkdir ./METAL/output # writes output of sex and subpop-meta
mkdir ./METAL/substudy # writes output of study-meta

# run meta_sex.q, meta_subpop.q, and meta_substudy.q