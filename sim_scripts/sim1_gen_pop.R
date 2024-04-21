library(tidyverse)
library(simgenphen)
library(bnpsd)
library(RColorBrewer)
library(popkin)
library(genio)
library(optparse) 

# terminal inputs
option_list = list(make_option(c( "-n", "--num"), type = "character", default = '1', 
              help = "numeric number that indicates number of rep", metavar = "character"))

opt_parser <- OptionParser(option_list = option_list)
opt <- parse_args(opt_parser)
# get values
rep_num <- opt$num # '1'

source("/hpc/group/ochoalab/tt207/meta_analysis_aim/make_corr_psi_tree.R")
setwd('/hpc/group/ochoalab/tt207/meta_analysis_aim/sim1_h08')

new_dir <- paste0('rep', rep_num)
dir.create(new_dir)
setwd(new_dir)

# define population structure
# 3 subpopulations
n1 <- 1000
n2 <- 1000
n3 <- 1000

# here's the labels (for simplicity, list all individuals of S1 first, then S2, then S3)
labs <- c(
  rep.int('S1', n1),
  rep.int('S2', n2),
  rep.int('S3', n3)
)

n_ind = length(labs)
# total number of individuals
length(labs)

# create random 1 male/2 female for sex 
sex = rbinom(length(labs), 1, 0.5) +1
table(sex)

# number of subpopulations "k_subpops"
k_subpops <- length(unique(labs))
k_subpops

# get its current coancestry, again to be rescaled in the end
tree_subpops <- make_corr_psi_tree( k_subpops )
coanc_subpops <- coanc_tree( tree_subpops )

# only half of individuals will be admixed if we include reference panel
n_ind_admix <-  n_ind # panels>????

# construct Q matrix and scale things appropriately
Fst <- 0.3

Q <- admix_prop_indep_subpops(labs)
Fst_temp <- fst_admix(Q, coanc_subpops)
coanc_factor = Fst/Fst_temp
coanc_subpops = coanc_subpops*coanc_factor

# png( '/datacommons/ochoalab/tiffany_data/meta_analysis_aim/sim1/sim1_phylo.png', width=6, height=5, res=300, units = 'in')
# par(mar = c(4, 0, 0, 2) + 1)
# plot_phylo(
#   tree_subpops,
#   xlab = "Coancestry",
#   xmax = 1,
#   leg_n = 5,
#   edge_width = 2
# )
# invisible( dev.off() )

# desired admixture matrix
tree_subpops <- scale_tree( tree_subpops, coanc_factor )

# save parameters
write_grm( 'Psi', coanc_subpops )
# Q = admix prop
write_matrix( 'Q', Q , ext = 'txt.gz' )

# the true coancestry matrix
coancestry <- coanc_admix( Q, coanc_subpops )
write_grm( 'Theta', coancestry )


##### draw genotypes
m_loci <- 500000
# draw all random Allele Freqs (AFs) and genotypes
# reuse the previous inbr_subpops, admix_proportions
out <- draw_all_admix(
  admix_proportions = Q,
  inbr_subpops = NULL,
  tree_subpops = tree_subpops,
  m_loci = m_loci,
  # NOTE by default p_subpops and p_ind are not returned, but here we will ask for them
  want_p_subpops = TRUE,
  # NOTE: asking for `p_ind` increases memory usage substantially,
  # so don't ask for it unless you're sure you want it!
  want_p_ind = TRUE
)
# genotypes
X <- out$X
# intermediate independent subpopulation AFs
p_subpops <- out$p_subpops
# ancestral AFs
p_anc <- out$p_anc
p_ind <- out$p_ind

##### draw trait
m_causal <- 100
herit <- 0.8
data_trait <- sim_trait_env(
  X,
  out$p_anc,
  m_causal,
  herit,
  fes = TRUE,
  env = 'gcat',
  k_subpops = k_subpops
)


# write bim/bed/fam
# fam file
fam <- tibble(fam = labs)
fam <- genio::make_fam(fam) %>% select(-sex, -pheno)

trait = data_trait$trait
fam_new = cbind(fam, sex, trait) %>% dplyr::rename(pheno = trait)
write_plink("1G_3000n_100causal_500000m", X, fam = fam_new)

# write covar
covar_file = cbind(fam$fam, fam$id, sex, trait) %>% as.data.frame() %>% dplyr::rename(famid = V1, iid = V2)
write.table(covar_file, "1G_covar_3000n_100causal_500000m.txt", col.names = TRUE, row.names = FALSE, quote = FALSE)

# write other files for generating future generations
# admix proportions = Q 
#write.table(admix_proportions, "/datacommons/ochoalab/tiffany_data/meta_analysis_aim/sim1_new/1G_admix_proportions_3000n_100causal_500000m.txt", sep = " ", col.names = TRUE, row.names = FALSE)
write.table(p_anc, "1G_p_anc_3000n_100causal_500000m.txt", sep = " ", col.names = TRUE, row.names = FALSE)
write.table(data_trait$causal_indexes, "1G_causal_id_3000n_100causal_500000m.txt", sep = " ", col.names = TRUE, row.names = FALSE)
# causal coeff
write.table(data_trait$causal_coeffs, "1G_causal_coeff_3000n_100causal_500000m.txt", col.names = TRUE, row.names = FALSE, quote = FALSE)
# and true ancestral allele frequencies
write_matrix( 'P', p_subpops, ext = 'txt.gz' )
##### run combined gmmat, subpop gmmat, and meta analysis
# split bim/bed/fam files by subpop
# run grm
dir.create('sex')
dir.create('subpop')