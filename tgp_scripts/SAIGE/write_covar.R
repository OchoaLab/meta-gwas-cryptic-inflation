library(tidyverse)
library(genio)
library(optparse)

# terminal inputs
option_list = list(make_option(c( "-n", "--num"), type = "character", default = '1', 
              help = "numeric number that indicates number of rep", metavar = "character"))

opt_parser <- OptionParser(option_list = option_list)
opt <- parse_args(opt_parser)
# get values
rep_num <- opt$num # '1'


# this is where our data is
setwd( paste0('/hpc/group/ochoalab/tgp-nygc-autosomes_ld_prune_1000kb_0.3_maf-0.01/rep-', rep_num ))
name = "simtrait.RData"

load(name)
# load phenotype and fixed covariates file
data <- read.table("data.phen", header = FALSE)
colnames(data) = c('famid', 'iid', 'trait')

data <- data %>%
  mutate(major_ancestry = case_when(
    famid %in% c("MSL", "YRI", "ESN", "GWD", "LWK", "ACB", "ASW") ~ "AFR",
    famid %in% c("CEU", "GBR", "IBS", "TSI", "FIN") ~ "EUR",
    famid %in% c("PJL", "GIH", "ITU", "STU", "BEB") ~ "SAS",
    famid %in% c("CHS", "CDX", "KHV", "CHB", "JPT", "CHD") ~ "EAS",
    famid %in% c("PEL", "MXL", "CLM", "PUR") ~ "AMR",
    TRUE ~ "Other"
  ))

grm <- read_grm( '../data' )
eigenvec <- read_eigenvec( '../data'  )

data <- data[ match( grm$fam$id, data$iid ), ]
# now that data is aligned, include all PCs as a single, convenient covariate
data$PCs <- eigenvec$eigenvec
# get sex column
fam = read_fam('../data')
data$sex <- fam$sex

data_saige_covar = data %>% select(famid, major_ancestry, id=iid, trait, sex, PCs) %>%
  mutate(trait = ifelse(trait < median(trait) , 0, 1))

#table(data_saige_covar$trait, data_saige_covar$famid)
table(data_saige_covar$trait, data_saige_covar$major_ancestry)
table(data_saige_covar$trait, data_saige_covar$sex)

write.table(data_saige_covar, 'covar_saige.txt',
            col.names = TRUE, row.names = FALSE, quote = FALSE, sep = " ")

print('wrote data_saige_covar')

#### sex
data_male <- data %>%
  filter(sex == 1)

grm <- read_grm( paste0("../data_male") )
eigenvec <- read_eigenvec( paste0("../data_male") )
data_male <- data_male[ match( grm$fam$id, data_male$iid ), ]
data_male$PCs <- eigenvec$eigenvec
data_saige_covar = data_male %>% select(famid, major_ancestry, id=iid, trait, PCs) %>%
  mutate(trait = ifelse(trait < median(trait) , 0, 1))
write.table(data_saige_covar, 'covar_saige_male.txt',
            col.names = TRUE, row.names = FALSE, quote = FALSE, sep = " ")
# 
# 
data_female <- data %>%
  filter(sex == 2)

grm <- read_grm( paste0( "../data_female") )
eigenvec <- read_eigenvec( paste0( "../data_female") )
data_female <- data_female[ match( grm$fam$id, data_female$iid ), ]
data_female$PCs <- eigenvec$eigenvec
data_saige_covar = data_female %>% select(famid, major_ancestry, id=iid, trait, sex, PCs) %>%
  mutate(trait = ifelse(trait < median(trait) , 0, 1))
write.table(data_saige_covar, 'covar_saige_female.txt',
            col.names = TRUE, row.names = FALSE, quote = FALSE, sep = " ")

print('wrote data_saige_covar sex')
#### subpop

table(data$major_ancestry)
# AFR_id = data %>% filter(major_ancestry == "AFR") %>% pull(famid) %>% unique()
# AMR_id = data %>% filter(major_ancestry == "AMR") %>% pull(famid) %>% unique()
# EAS_id = data %>% filter(major_ancestry == "EAS") %>% pull(famid) %>% unique()
# EUR_id = data %>% filter(major_ancestry == "EUR") %>% pull(famid) %>% unique()
# SAS_id = data %>% filter(major_ancestry == "SAS") %>% pull(famid) %>% unique()
# write.table(AFR_id, "../afr_id.txt", col.names = FALSE, row.names = FALSE, quote = FALSE)
# write.table(AMR_id, "../amr_id.txt", col.names = FALSE, row.names = FALSE, quote = FALSE)
# write.table(EAS_id, "../eas_id.txt", col.names = FALSE, row.names = FALSE, quote = FALSE)
# write.table(EUR_id, "../eur_id.txt", col.names = FALSE, row.names = FALSE, quote = FALSE)
# write.table(SAS_id, "../sas_id.txt", col.names = FALSE, row.names = FALSE, quote = FALSE)

data_afr <- data %>%
  filter(major_ancestry == "AFR")
grm <- read_grm( paste0( "../data_afr") )
eigenvec <- read_eigenvec( paste0("../data_afr") )
data_afr <- data_afr[ match( grm$fam$id, data_afr$iid ), ]
data_afr$PCs <- eigenvec$eigenvec
data_saige_covar = data_afr %>% select(famid,  id=iid, trait, sex, PCs) %>%
  mutate(trait = ifelse(trait < median(trait) , 0, 1))
write.table(data_saige_covar, "covar_saige_afr.txt",
            col.names = TRUE, row.names = FALSE, quote = FALSE, sep = " ")

data_amr <- data %>%
  filter(major_ancestry == "AMR")
grm <- read_grm( paste0( "../data_amr") )
eigenvec <- read_eigenvec( paste0("../data_amr") )
data_amr <- data_amr[ match( grm$fam$id, data_amr$iid ), ]
data_amr$PCs <- eigenvec$eigenvec
data_saige_covar = data_amr %>% select(famid,  id=iid, trait, sex, PCs) %>%
  mutate(trait = ifelse(trait < median(trait) , 0, 1))
write.table(data_saige_covar, "covar_saige_amr.txt",
            col.names = TRUE, row.names = FALSE, quote = FALSE, sep = " ")

data_eas <- data %>%
  filter(major_ancestry == "EAS")
grm <- read_grm( paste0( "../data_eas") )
eigenvec <- read_eigenvec( paste0("../data_eas") )
data_eas <- data_eas[ match( grm$fam$id, data_eas$iid ), ]
data_eas$PCs <- eigenvec$eigenvec
data_saige_covar = data_eas %>% select(famid,  id=iid, trait, sex, PCs) %>%
  mutate(trait = ifelse(trait < median(trait) , 0, 1))
write.table(data_saige_covar, "covar_saige_eas.txt",
            col.names = TRUE, row.names = FALSE, quote = FALSE, sep = " ")

data_eur <- data %>%
  filter(major_ancestry == "EUR")
grm <- read_grm( paste0( "../data_eur") )
eigenvec <- read_eigenvec( paste0("../data_eur") )
data_eur <- data_eur[ match( grm$fam$id, data_eur$iid ), ]
data_eur$PCs <- eigenvec$eigenvec
data_saige_covar = data_eur %>% select(famid,  id=iid, trait, sex, PCs) %>%
  mutate(trait = ifelse(trait < median(trait) , 0, 1))
write.table(data_saige_covar, "covar_saige_eur.txt",
            col.names = TRUE, row.names = FALSE, quote = FALSE, sep = " ")

data_sas <- data %>%
  filter(major_ancestry == "SAS")
grm <- read_grm( paste0( "../data_sas") )
eigenvec <- read_eigenvec( paste0("../data_sas") )
data_sas <- data_sas[ match( grm$fam$id, data_sas$iid ), ]
data_sas$PCs <- eigenvec$eigenvec
data_saige_covar = data_sas %>% select(famid,  id=iid, trait, sex, PCs) %>%
  mutate(trait = ifelse(trait < median(trait) , 0, 1))
write.table(data_saige_covar, "covar_saige_sas.txt",
            col.names = TRUE, row.names = FALSE, quote = FALSE, sep = " ")

print('wrote data_saige_covar subpop')