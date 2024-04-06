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

setwd('/datacommons/ochoalab/tiffany_data/meta_analysis_aim/sim4')

new_dir <- paste0('rep', rep_num)
dir.create(new_dir)
setwd(new_dir)


# define population structure
# 1 single population
n1 <- 3000

# here's the labels (for simplicity, list all individuals of S1 first, then S2, then S3)
labs <- c(
  rep.int('S1', n1)
)

# total number of individuals
length(labs)

# create random 1 male/2 female for sex 
sex = rbinom(length(labs), 1, 0.5) +1
table(sex)

# number of subpopulations "k_subpops"
k_subpops <- length(unique(labs))
k_subpops

# desired admixture matrix
admix_proportions <- admix_prop_indep_subpops(labs)

# got a numeric matrix with a single 1 value per row
# (denoting the sole subpopulation from which each individual draws its ancestry)
head(admix_proportions, 2)

Fst <- 0.3
# subpopulation FST vector, unnormalized so far
inbr_subpops <- 1 : k_subpops
# normalized to have the desired FST
# NOTE fst is a function in the `popkin` package
inbr_subpops <- inbr_subpops / fst(inbr_subpops) * Fst
# verify FST for the intermediate subpopulations
fst(inbr_subpops)

# get coancestry of the admixed individuals
#coancestry <- coanc_admix(admix_proportions, inbr_subpops)
coancestry <- tcrossprod(admix_proportions) * inbr_subpops

# before getting FST for individuals, weigh then inversely proportional to subpop sizes
weights <- weights_subpops(labs) # function from `popkin` package

##### draw genotypes
m_loci <- 500000
# draw all random Allele Freqs (AFs) and genotypes
# reuse the previous inbr_subpops, admix_proportions
out <- draw_all_admix(
  admix_proportions = admix_proportions,
  inbr_subpops = inbr_subpops,
  m_loci = m_loci,
  # NOTE by default p_subpops and p_ind are not returned, but here we will ask for them
  want_p_subpops = TRUE,
  # NOTE: asking for `p_ind` increases memory usage substantially,
  # so don't ask for it unless you're sure you want it!
  want_p_ind = TRUE
)
# genotypes
X <- out$X
# ancestral AFs
p_anc <- out$p_anc
# intermediate independent subpopulation AFs
p_subpops <- out$p_subpops
# individual-specific AFs
p_ind <- out$p_ind

##### draw trait
m_causal <- 100
herit <- 0.6
data_trait <- sim_trait_env(
  X,
  out$p_anc,
  m_causal,
  herit,
  env = 'gcat',
  k_subpops = k_subpops
)

causal_id = data_trait$causal_indexes
# write bim/bed/fam
# fam file
fam <- tibble(fam = labs)
fam <- genio::make_fam(fam) %>% select(-sex, -pheno)

trait = data_trait$trait
fam_new = cbind(fam, sex, trait) %>% dplyr::rename(pheno = trait)
write_plink("1G_3000n_100causal_500000m", X, fam = fam_new)

# write covar
covar_file = cbind(fam$fam, fam$id, sex, trait) %>% as.data.frame() %>% dplyr::rename(famid = V1, iid = V2)
write.table(covar_file, "1G_covar_3000n_100causal_500000m", col.names = TRUE, row.names = FALSE, quote = FALSE)

# write other files for generating future generations
write.table(admix_proportions, "1G_admix_proportions_3000n_100causal_500000m.txt", sep = " ", col.names = TRUE, row.names = FALSE)
write.table(p_anc, "1G_p_anc_3000n_100causal_500000m.txt", sep = " ", col.names = TRUE, row.names = FALSE)
write.table(causal_id, "1G_causal_id_3000n_100causal_500000m.txt", sep = " ", col.names = TRUE, row.names = FALSE)

##### run combined gmmat, subpop gmmat, and meta analysis
# split bim/bed/fam files by subpop
# run grm
dir.create('sex')