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
setwd( paste0('/datacommons/ochoalab/tiffany_data/meta_analysis_aim/sim', sim_num, '/rep', rep_num ))
name = "30G_3000n_100causal_500000m"

# load phenotype and fixed covariates file
data <- read.table("30G_covar_3000n_100causal_500000m.txt", header = TRUE)

grm <- read_grm( name )
eigenvec <- read_eigenvec( name )

data <- data[ match( grm$fam$id, data$iid ), ]
# now that data is aligned, include all PCs as a single, convenient covariate
data$PCs <- eigenvec$eigenvec

data_saige_covar = data %>% select(famid, id=iid, trait, sex, PCs) %>%
  mutate(trait = ifelse(trait < 0 , 0, 1))
  #mutate(sex = ifelse(sex == 2, 1, 0), trait = ifelse(trait < 0 , 0, 1))
table(data_saige_covar$trait)
table(data_saige_covar$sex)
table(data_saige_covar$trait, data_saige_covar$sex)

write.table(data_saige_covar, paste0("/datacommons/ochoalab/tiffany_data/meta_analysis_aim/sim", sim_num, '/rep', rep_num, '/covar_saige_', name, '.txt'),
            col.names = TRUE, row.names = FALSE, quote = FALSE, sep = " ")

print('wrote data_saige_covar')

#### sex
setwd('./sex')
data_male <- data %>%
  filter(sex == 1)

grm <- read_grm( paste0(name, "_male") )
eigenvec <- read_eigenvec( paste0(name, "_male") )
data_male <- data_male[ match( grm$fam$id, data_male$iid ), ]
data_male$PCs <- eigenvec$eigenvec
data_saige_covar = data_male %>% select(famid, id=iid, trait, sex, PCs) %>%
  mutate(trait = ifelse(trait < 0 , 0, 1))
write.table(data_saige_covar, paste0('covar_saige_', name, '_male.txt'),
            col.names = TRUE, row.names = FALSE, quote = FALSE, sep = " ")
# 
# 
data_female <- data %>%
  filter(sex == 2)

grm <- read_grm( paste0( name, "_female") )
eigenvec <- read_eigenvec( paste0( name, "_female") )
data_female <- data_female[ match( grm$fam$id, data_female$iid ), ]
data_female$PCs <- eigenvec$eigenvec
data_saige_covar = data_female %>% select(famid, id=iid, trait, sex, PCs) %>%
  mutate(trait = ifelse(trait < 0 , 0, 1))
write.table(data_saige_covar, paste0('covar_saige_', name, '_female.txt'),
            col.names = TRUE, row.names = FALSE, quote = FALSE, sep = " ")
#### subpop
# setwd('../subpop')
# data_S1 <- data %>% 
#   filter(famid == "S1")
# grm <- read_grm( paste0(name, "_S1") )
# eigenvec <- read_eigenvec( paste0(name, "_S1") )
# data_S1 <- data_S1[ match( grm$fam$id, data_S1$iid ), ]
# data_S1$PCs <- eigenvec$eigenvec
# data_saige_covar = data_S1 %>% select(famid, id=iid, trait, sex, PCs) %>% 
#   mutate(trait = ifelse(trait < 0 , 0, 1))
# write.table(data_saige_covar, paste0('covar_saige_', name, '_S1.txt'), 
#             col.names = TRUE, row.names = FALSE, quote = FALSE, sep = " ")
# 
# data_S2 <- data %>% 
#   filter(famid == "S2")
# grm <- read_grm( paste0(name, "_S2") )
# eigenvec <- read_eigenvec( paste0(name, "_S2") )
# data_S2 <- data_S2[ match( grm$fam$id, data_S2$iid ), ]
# data_S2$PCs <- eigenvec$eigenvec
# data_saige_covar = data_S2 %>% select(famid, id=iid, trait, sex, PCs) %>% 
#   mutate(trait = ifelse(trait < 0 , 0, 1))
# write.table(data_saige_covar, paste0('covar_saige_', name, '_S2.txt'), 
#             col.names = TRUE, row.names = FALSE, quote = FALSE, sep = " ")
# 
# data_S3 <- data %>% 
#   filter(famid == "S3")
# grm <- read_grm( paste0(name, "_S3") )
# eigenvec <- read_eigenvec( paste0(name, "_S3") )
# data_S3 <- data_S3[ match( grm$fam$id, data_S3$iid ), ]
# data_S3$PCs <- eigenvec$eigenvec
# data_saige_covar = data_S3 %>% select(famid, id=iid, trait, sex, PCs) %>% 
#   mutate(trait = ifelse(trait < 0 , 0, 1))
# write.table(data_saige_covar, paste0('covar_saige_', name, '_S3.txt'), 
#             col.names = TRUE, row.names = FALSE, quote = FALSE, sep = " ")


