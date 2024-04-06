library(bnpsd)
library(simfam)
library(genio)
library(simgenphen)
library(popkin)
library(tidyverse)
library(optparse) 

# terminal inputs
option_list = list(make_option(c( "-n", "--num"), type = "character", default = '1', 
                               help = "numeric number that indicates number of rep", metavar = "character"))

opt_parser <- OptionParser(option_list = option_list)
opt <- parse_args(opt_parser)
# get values
rep_num <- opt$num # '1'

setwd(paste0('/datacommons/ochoalab/tiffany_data/meta_analysis_aim/sim4/rep', rep_num))

print('start step 4')
##### draw trait
plink = read_plink("30G_3000n_100causal_500000m")
print('finish reading')
dim(plink$X)

X_G = plink$X
fam_G = plink$fam
# ancestral allele freq from first generation
p_anc = read.table('1G_p_anc_3000n_100causal_500000m.txt', header = TRUE) %>% pull(x)

## pedigree data
# read fam/fam id
fam = read.table("pedigree_fam_30G.txt", header = TRUE)
load("pedigree_ids_30G.RData")

##### draw trait
m_causal <- 100
herit <- 0.6
k_subpops <- 1
### draw trait for last generation? with ancestral af.
print("draw trait")
data_trait <- sim_trait_env(
  X_G,
  p_anc,
  m_causal,
  herit,
  env = NA, # gcat or no env??
  k_subpops = NA
)

##### calculate kinship and expected admixture proportions
## admix prop
admix_proportions_1 = read.table("1G_admix_proportions_3000n_100causal_500000m.txt", header = TRUE) %>% as.matrix()
## inbr_subpop
Fst <- 0.3
k_subpops = ncol(admix_proportions_1)
# subpopulation FST vector, unnormalized so far
inbr_subpops <- 1 : k_subpops
# normalized to have the desired FST
# NOTE fst is a function in the `popkin` package
inbr_subpops <- inbr_subpops / fst(inbr_subpops) * Fst
## coancestry
#coancestry <- coanc_admix(admix_proportions_1, inbr_subpops)

coancestry <- tcrossprod(admix_proportions_1) * inbr_subpops
print('coancestry calculated')
kinship_1 <- coanc_to_kinship(coancestry) ## kinship_1 = coancestry? yes # kinship missing rowname for parents
print('kinship calculated')
rownames(kinship_1) <- ids[[1]]
colnames(kinship_1) <- ids[[1]]

print("generate kinship of last generation")
kinship_G <- kinship_last_gen( kinship_1, fam, ids )
rownames(admix_proportions_1) <- ids[[1]]

#print("generate admix prop of last generation")
#admix_proportions_G <- admix_last_gen( admix_proportions_1, fam, ids )

#table(fam_G$pheno)
# covar
covar_file = cbind(fam_G$fam, fam_G$id, fam_G$sex, data_trait$trait) %>% as.data.frame() %>% dplyr::rename(famid = V1, iid = V2, sex = V3, trait = V4)
write.table(covar_file, "30G_covar_3000n_100causal_500000m.txt", col.names = TRUE, row.names = FALSE, quote = FALSE)
# causal indices
write.table(data_trait$causal_indexes, "30G_causal_id_3000n_100causal_500000m.txt", col.names = TRUE, row.names = FALSE, quote = FALSE)
# causal coeff
write.table(data_trait$causal_coeffs, "30G_causal_coeff_3000n_100causal_500000m.txt", col.names = TRUE, row.names = FALSE, quote = FALSE)
# admixture proportions of last gen
#write.table(admix_proportions_G, "/datacommons/ochoalab/tiffany_data/meta_analysis_aim/sim4/30G_admix_proportions_G_3000n_100causal_500000m.txt", sep = " ", col.names = TRUE, row.names = FALSE)
# kinship of last gen
genio::write_grm("30G_kinship_G_3000n_100causal_500000m", kinship_G)

