library(tidyverse)
library(genio)
library(optparse)

# terminal inputs
option_list = list(make_option(c( "-n", "--num"), type = "character", default = '1', 
              help = "numeric number that indicates number of rep", metavar = "character"),
              make_option(c( "-s", "--sim"), type = "character", default = '1',
              help = "numeric number that indicates simulation scenario number", metavar = "character"))

opt_parser <- OptionParser(option_list = option_list)
opt <- parse_args(opt_parser)
# get values
rep_num <- opt$num # '1'
sim_num <- opt$sim # '1'

# this is where our data is
setwd( paste0('/hpc/group/ochoalab/tt207/meta_analysis_aim/sim', sim_num, '/rep', rep_num ))
name = "1G_3000n_100causal_500000m"

# load phenotype and fixed covariates file
data <- read.table("1G_covar_3000n_100causal_500000m.txt", header = TRUE)


#### subpop
setwd('./subpop')
data_S1 <- data[1:1000,]
grm <- read_grm( paste0(name, "_S1") )
eigenvec <- read_eigenvec( paste0(name, "_S1") )
data_S1 <- data_S1[ match( grm$fam$id, data_S1$iid ), ]
data_S1$PCs <- eigenvec$eigenvec
data_saige_covar = data_S1 %>% select(famid, id=iid, trait, sex, PCs) #%>%
  #mutate(trait = ifelse(trait < median(trait) , 0, 1))
write.table(data_saige_covar, paste0('covar_saige_', name, '_S1_quant.txt'),
            col.names = TRUE, row.names = FALSE, quote = FALSE, sep = " ")

data_S2 <- data[1001:2000,]
grm <- read_grm( paste0(name, "_S2") )
eigenvec <- read_eigenvec( paste0(name, "_S2") )
data_S2 <- data_S2[ match( grm$fam$id, data_S2$iid ), ]
data_S2$PCs <- eigenvec$eigenvec
data_saige_covar = data_S2 %>% select(famid, id=iid, trait, sex, PCs) #%>%
  #mutate(trait = ifelse(trait < median(trait) , 0, 1))
write.table(data_saige_covar, paste0('covar_saige_', name, '_S2_quant.txt'),
            col.names = TRUE, row.names = FALSE, quote = FALSE, sep = " ")

data_S3 <- data[2001:3000,]
grm <- read_grm( paste0(name, "_S3") )
eigenvec <- read_eigenvec( paste0(name, "_S3") )
data_S3 <- data_S3[ match( grm$fam$id, data_S3$iid ), ]
data_S3$PCs <- eigenvec$eigenvec
data_saige_covar = data_S3 %>% select(famid, id=iid, trait, sex, PCs) #%>%
  #mutate(trait = ifelse(trait < median(trait) , 0, 1))
write.table(data_saige_covar, paste0('covar_saige_', name, '_S3_quant.txt'),
            col.names = TRUE, row.names = FALSE, quote = FALSE, sep = " ")


print('wrote data_saige_covar subpop')