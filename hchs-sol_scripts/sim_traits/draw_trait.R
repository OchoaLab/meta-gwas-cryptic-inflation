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

plink = read_plink("/data/irb/biostatisticsbioinformatics/pro00108518/hchs-sol/Ia/data_qc")
X = plink$X
kinship = read_grm("/data/irb/biostatisticsbioinformatics/pro00108518/hchs-sol/Ia/data_qc_popkin_rom")
##### draw trait
m_causal <- 150
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
write.table(trait, paste0("./rep_", rep_num, "/sim_trait_150.txt"), col.names = FALSE, row.names = FALSE)
write.table(data_trait$causal_indexes, paste0("./rep_", rep_num, "/causal_id_150.txt"), sep = " ", col.names = TRUE, row.names = FALSE)
# causal coeff
write.table(data_trait$causal_coeffs, paste0("./rep_", rep_num, "/causal_coeff_150.txt"), col.names = TRUE, row.names = FALSE, quote = FALSE)

pheno = read.csv("/data/irb/biostatisticsbioinformatics/pro00108518/hchs-sol/Ia/heritability/hchs_phen.csv", header = TRUE)
# read eigen
grm <- read_grm( '../../data_qc_std_mor' )
eigenvec <- read_eigenvec( '../data_qc_std_mor' )

pheno <- pheno[ match( grm$fam$id, pheno$SUBJECT_ID ), ]
# now that data is aligned, include all PCs as a single, convenient covariate
pheno$PCs <- eigenvec$eigenvec

# read sim_trait.txt and combine with phenofile
simtrait = read.table(paste0("./rep_", rep_num, "/sim_trait_150.txt"), header = FALSE)$V1
pheno_simtrait = cbind(simtrait, pheno)
covar <- pheno_simtrait %>%
  select(SUBJECT_ID, sex = GENDERNUM, simtrait, age = AGE, PCs) 

write.table(covar, paste0("./rep_", rep_num, "/covar_simtrait_150.txt"), col.names = TRUE,
            row.names = FALSE, quote = FALSE)