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
setwd(paste0('/datacommons/ochoalab/tiffany_data/meta_analysis_aim/sim3/rep', rep_num))

# sim 3 : 3 subpopulations, admixture across subpopulations
n = 3000
# number of generations
G = 30
## pedigree data
# read fam/fam id
fam = read.table("pedigree_fam_30G.txt", header = TRUE)
load("pedigree_ids_30G.RData")


# draw genotypes X through pedigree
# read X genotype file from sim1 (first generation)
plink = read_plink(paste0('/datacommons/ochoalab/tiffany_data/meta_analysis_aim/sim1/rep', rep_num, '/1G_3000n_100causal_500000m'))
X_1 = plink$X
X_famid = plink$fam$fam
#rownames(X_1)
# need to rewrite famid's to indicate subpop
famid = rep(X_famid, G)
fam$fam <- famid
# remove individuals without descendants
fam <- prune_fam( fam, ids[[G]] )

# to generate X of last generation....
# add "1-" to individual id's
X_1_id = colnames(X_1) 

colnames(X_1) = paste0("1-", X_1_id)

# generate fam file for last generation
fam_G = tail(fam, n)
# generate last generation
print("generate last generation X_G")

name_out <- "30G_3000n_100causal_500000m"
m_loci = 500000

## NEW version that is a bit more memory efficient
# a global variable updated as we go
m_last <- 0
# simulator function
sim_chunk <- function( m_chunk ) {
    # these are the locus indexes to process right now:
    indexes <- m_last + ( 1 : m_chunk )
    
    X_G <- geno_last_gen( X_1[ indexes, , drop = FALSE ], fam, ids )
    rownames(X_G) <- NULL
    # create dummy bim to go with this
    bim <- make_bim( n = m_chunk )
    # this creates IDs (and positions) that don't repeat/clash
    bim$id <- bim$id + m_last
    bim$pos <- bim$id
    #print(bim)
    # update global value (use <<-) for next round
    m_last <<- m_last + m_chunk
    return( list( X = X_G, bim = bim ) )
}
# simulate data and write it on the go!
sim_and_write_plink( sim_chunk, m_loci, fam_G, name_out )

