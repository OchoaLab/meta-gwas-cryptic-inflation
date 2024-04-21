library(simfam)
library(optparse) 

# terminal inputs
option_list = list(make_option(c( "-n", "--num"), type = "character", default = '1', 
                               help = "numeric number that indicates number of rep", metavar = "character"))

opt_parser <- OptionParser(option_list = option_list)
opt <- parse_args(opt_parser)
# get values
rep_num <- opt$num # '1'

setwd('/hpc/group/ochoalab/tt207/meta_analysis_aim/sim3_h08/')
new_dir <- paste0('rep', rep_num)
dir.create(new_dir)
setwd(new_dir)

# sim 3 : 3 subpopulations, admixture across subpopulations
n = 3000
# number of generations
G = 30
data <- sim_pedigree( n, G )
ids = data$ids

print('write fam file')
write.table(data$fam, "pedigree_fam_30G.txt",
            col.names = TRUE, row.names = FALSE, quote = FALSE)

print('write fam ids file')
save( ids, file = "pedigree_ids_30G.RData") 
