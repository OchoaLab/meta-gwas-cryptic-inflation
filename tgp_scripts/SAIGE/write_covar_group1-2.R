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

# get sex column
fam = read_fam('../data')
data$sex <- fam$sex

data_group1 <- data %>%
  filter(major_ancestry == "AFR" | major_ancestry == "SAS")
grm <- read_grm( paste0( "../data_group1") )
eigenvec <- read_eigenvec( paste0("../data_group1") )
data_group1 <- data_group1[ match( grm$fam$id, data_group1$iid ), ]
data_group1$PCs <- eigenvec$eigenvec
data_saige_covar = data_group1 %>% select(famid,  major_ancestry, id=iid, trait, sex, PCs) %>%
  mutate(trait = ifelse(trait < median(trait) , 0, 1))
table(data_saige_covar$major_ancestry)
write.table(data_saige_covar, "covar_saige_group1.txt",
            col.names = TRUE, row.names = FALSE, quote = FALSE, sep = " ")

data_group2 <- data %>%
  filter(major_ancestry == "AMR" | major_ancestry == "EAS" | major_ancestry == "EUR")
grm <- read_grm( paste0( "../data_group2") )
eigenvec <- read_eigenvec( paste0("../data_group2") )
data_group2 <- data_group2[ match( grm$fam$id, data_group2$iid ), ]
data_group2$PCs <- eigenvec$eigenvec
data_saige_covar = data_group2 %>% select(famid,  major_ancestry, id=iid, trait, sex, PCs) %>%
  mutate(trait = ifelse(trait < median(trait) , 0, 1))
table(data_saige_covar$major_ancestry)
table(data_saige_covar$sex)
write.table(data_saige_covar, "covar_saige_group2.txt",
            col.names = TRUE, row.names = FALSE, quote = FALSE, sep = " ")

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

# group1 = data %>% filter(major_ancestry == "SAS" | major_ancestry == "AFR") %>% pull(famid) %>% unique()
#group2 = data %>% filter( major_ancestry == "AMR" | major_ancestry == "EAS" | major_ancestry == "EUR") %>% pull(famid) %>% unique()
# write.table(group1, "../group1_id.txt", col.names = FALSE, row.names = FALSE, quote = FALSE)
#write.table(group2, "../group2_id.txt", col.names = FALSE, row.names = FALSE, quote = FALSE)



print('wrote data_saige_covar group1 group2')