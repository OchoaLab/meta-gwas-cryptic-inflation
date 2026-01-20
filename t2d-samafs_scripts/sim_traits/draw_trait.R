library(tidyverse)
library(simtrait)
library(genio)
library(popkin)
library(optparse) 

# terminal inputs
option_list = list(make_option(c( "-a", "--array"), type = "character", default = '1', 
                               help = "numeric number that indicates number of rep", metavar = "character"))

opt_parser <- OptionParser(option_list = option_list)
opt <- parse_args(opt_parser)
# get values
rep_num <- opt$array # '1'

plink = read_plink("/home/tt207/pro00108518/t2d-samafs/study2/exome_chip/exome_chip_qc")
X = plink$X
kinship = read_grm("/home/tt207/pro00108518/t2d-samafs/study2/exome_chip/exome_chip_qc_popkin_rom")
##### draw trait
m_causal <- 100
herit <- 0.8
data_trait <- sim_trait(
  X,
  p_anc = NULL,# ancestral allele frequency
  kinship = kinship$kinship,
  m_causal,
  herit,
  fes = TRUE
)

trait = data_trait$trait
write.table(trait, paste0("./rep_", rep_num, "/sim_trait.txt"), col.names = FALSE, row.names = FALSE)
write.table(data_trait$causal_indexes, paste0("./rep_", rep_num, "/causal_id.txt"), sep = " ", col.names = TRUE, row.names = FALSE)
# causal coeff
write.table(data_trait$causal_coeffs, paste0("./rep_", rep_num, "/causal_coeff.txt"), col.names = TRUE, row.names = FALSE, quote = FALSE)

#########
pheno = read.table("/home/tt207/pro00108518/t2d-samafs/study2/raw/PhenotypeFiles/phs000462.v2.pht002844.v2.p1.c1.T2D_GENES_SAMAFS_Project2_WGS_Subject_Phenotypes.DS-DIAB-IRB-RD.txt.gz", header = TRUE)
# read eigen
grm <- read_grm( '/home/tt207/pro00108518/t2d-samafs/study2/exome_chip/exome_chip_qc' )
eigenvec <- read_eigenvec( '/home/tt207/pro00108518/t2d-samafs/study2/exome_chip/exome_chip_qc' )

pheno <- pheno[ match( grm$fam$id, pheno$SUBJECT_ID ), ]
# now that data is aligned, include all PCs as a single, convenient covariate
pheno$PCs <- eigenvec$eigenvec

# read sim_trait.txt and combine with phenofile
simtrait = read.table(paste0("./rep_", rep_num, "/sim_trait.txt"), header = FALSE)$V1
pheno_simtrait = cbind(simtrait, pheno)
covar <- pheno_simtrait %>%
  select(SUBJECT_ID, sex, simtrait, age, PCs)

write.table(covar, paste0("./rep_", rep_num, "/covar_simtrait.txt"), col.names = TRUE,
            row.names = FALSE, quote = FALSE)