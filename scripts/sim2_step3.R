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
setwd(paste0('/hpc/group/ochoalab/tt207/meta_analysis_aim/sim2_h08/rep', rep_num))


# draw trait
plink_file = paste0('/hpc/group/ochoalab/tt207/meta_analysis_aim/sim2_h08/rep', rep_num, '/30G_3000n_100causal_500000m')
plink = read_plink(plink_file)
print('finish reading plink file')
dim(plink$X)

X_G = plink$X
fam_G = plink$fam
# ancestral allele freq from first generation
p_anc = read.table(paste0('/hpc/group/ochoalab/tt207/meta_analysis_aim/sim1_h08/rep', rep_num, '/1G_p_anc_3000n_100causal_500000m.txt'), header = TRUE) %>% pull(x)
m_causal <- 100
herit <- 0.8
k_subpops <- 3
### draw trait for last generation? with ancestral af from sim1
print("draw trait")
data_trait <- sim_trait_env(
  X_G,
  p_anc,
  m_causal,
  herit,
  env = 'gcat',
  k_subpops = k_subpops,
  fes = TRUE
)

## combine pedigree data
combined_fam <- data.frame()
list_ids <- list()

subpop = 3
for (x in 1:subpop){
  # read fam/fam id
  fam = read.table(paste0('/hpc/group/ochoalab/tt207/meta_analysis_aim/sim2_h08/rep', rep_num, '/subpop/pedigree_fam_30G_S', x, "_new.txt"), header = TRUE)
  combined_fam <- rbind(combined_fam, fam)
  
  load(paste0('/hpc/group/ochoalab/tt207/meta_analysis_aim/sim2_h08/rep', rep_num, '/subpop/pedigree_ids_30G_S', x, '_new.RData'))
  list_ids[[x]] <- new_ids
}

# combine nested list (combines 3 subpop)
# results in list for 30 generations, each with 3000 individuals
combined_ids <- list()
# Iterate over the indices of the nested lists
for (i in seq_along(list_ids[[1]])) {
  # Combine the elements from all three lists at the current index
  combined_elements <- c(list_ids[[1]][[i]], list_ids[[2]][[i]], list_ids[[3]][[i]])
  # Append the combined elements to the combined list
  combined_ids[[i]] <- combined_elements
}


## admix prop
admix_proportions_1 = read.table(paste0('/hpc/group/ochoalab/tt207/meta_analysis_aim/sim1_h08/rep',
                                        rep_num, '/Q.txt.gz')) %>%
  as.matrix()
colnames(admix_proportions_1) = c("S1", "S2", "S3")
coanc_subpop = read_grm(paste0('/hpc/group/ochoalab/tt207/meta_analysis_aim/sim1_h08/rep',
                                        rep_num, '/Psi'))

coancestry <- coanc_admix(admix_proportions_1, coanc_subpop$kinship)

kinship_1 <- coanc_to_kinship(coancestry) ## kinship_1 = coancestry? yes # kinship missing rowname for parents
rownames(kinship_1) <- combined_ids[[1]]
colnames(kinship_1) <- combined_ids[[1]]

print("generate kinship of last generation")
kinship_G <- kinship_last_gen( kinship_1, combined_fam, combined_ids )
rownames(admix_proportions_1) <- combined_ids[[1]]

print("generate admix prop of last generation")
admix_proportions_G <- admix_last_gen( admix_proportions_1, combined_fam, combined_ids )

covar_file = cbind(fam_G$fam, fam_G$id, fam_G$sex, data_trait$trait) %>% as.data.frame() %>% dplyr::rename(famid = V1, iid = V2, sex = V3, trait = V4)
write.table(covar_file, paste0('30G_covar_3000n_100causal_500000m_fes.txt'), col.names = TRUE, row.names = FALSE, quote = FALSE)
# causal indices
write.table(data_trait$causal_indexes, paste0( '30G_causal_id_3000n_100causal_500000m_fes.txt'), col.names = TRUE, row.names = FALSE, quote = FALSE)
# causal coeff
write.table(data_trait$causal_coeffs, paste0('30G_causal_coeff_3000n_100causal_500000m_fes.txt'), col.names = TRUE, row.names = FALSE, quote = FALSE)
# admixture proportions of last gen
write.table(admix_proportions_G, paste0('30G_admix_proportions_G_3000n_100causal_500000m.txt'), sep = " ", col.names = TRUE, row.names = FALSE)
# kinship of last gen
genio::write_grm(paste0( '30G_kinship_G_3000n_100causal_500000m'), kinship_G)

