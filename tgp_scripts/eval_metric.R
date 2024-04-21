library(tidyverse)
library(simtrait)

setwd('/hpc/group/ochoalab/tgp-nygc-autosomes_ld_prune_1000kb_0.3_maf-0.01/')
# terminal inputs

library(optparse) 

# terminal inputs
option_list = list(
  make_option(c( "-r", "--replicate"), type = "character", default = 'sim1', 
              help = "replicate: 1,2,3,...", metavar = "character"))

opt_parser <- OptionParser(option_list = option_list)
opt <- parse_args(opt_parser)
# get values
rep <- opt$replicate # sim1
# iterate for the 10 replicates
combined_df <- data.frame()
for (rep_num in rep) {
  print(rep_num)
  df_all = read.table(paste0('rep-', rep_num, '/saige_output.txt'), header = TRUE) 
  all_snps = df_all %>% select(CHR, POS)
  # load subpop files
  df_afr = read.table(paste0('rep-', rep_num, '/saige_output_afr.txt'), header = TRUE)
  df_amr = read.table(paste0('rep-', rep_num, '/saige_output_amr.txt'), header = TRUE)
  df_eas = read.table(paste0('rep-', rep_num, '/saige_output_eas.txt'), header = TRUE)
  df_eur = read.table(paste0('rep-', rep_num, '/saige_output_eur.txt'), header = TRUE)
  df_sas = read.table(paste0('rep-', rep_num, '/saige_output_sas.txt'), header = TRUE)
  # read sex stratified analysis results
  df_male = read.table(paste0('rep-', rep_num, '/saige_output_male.txt'), header = TRUE) 
  df_female = read.table(paste0('rep-', rep_num, '/saige_output_female.txt'), header = TRUE) 

  # meta
  meta_sex <- read.table(paste0("METAL/output/output_sex_", rep_num, "1.txt"), sep = "\t", stringsAsFactors=FALSE, quote = "", header = TRUE) %>% 
    separate(MarkerName, c("CHR", "POS")) %>% mutate(CHR = as.numeric(CHR), POS = as.numeric(POS)) %>% arrange(CHR, POS) %>% dplyr::rename(p.value = P.value)

  meta_subpop <- read.table(paste0("METAL/output/output_subpop_", rep_num, "1.txt"), sep = "\t", stringsAsFactors=FALSE, quote = "", header = TRUE) %>% 
    separate(MarkerName, c("CHR", "POS")) %>% mutate(CHR = as.numeric(CHR), POS = as.numeric(POS)) %>% arrange(CHR, POS)  %>% dplyr::rename(p.value = P.value)

  # make sure each subanalyses contains ALL snps
  df_afr_complete = merge(all_snps, df_afr, by = c("CHR", "POS"), all.x = TRUE) %>% arrange(CHR, POS)
  df_amr_complete = merge(all_snps, df_amr, by = c("CHR", "POS"), all.x = TRUE) %>% arrange(CHR, POS)
  df_eas_complete = merge(all_snps, df_eas, by = c("CHR", "POS"), all.x = TRUE) %>% arrange(CHR, POS)
  df_eur_complete = merge(all_snps, df_eur, by = c("CHR", "POS"), all.x = TRUE) %>% arrange(CHR, POS)
  df_sas_complete = merge(all_snps, df_sas, by = c("CHR", "POS"), all.x = TRUE) %>% arrange(CHR, POS)
  df_male_complete = merge(all_snps, df_male, by = c("CHR", "POS"), all.x = TRUE) %>% arrange(CHR, POS)
  df_female_complete = merge(all_snps, df_female, by = c("CHR", "POS"), all.x = TRUE) %>% arrange(CHR, POS)

  file_names = c("df_all", "df_afr_complete", "df_amr_complete",
                "df_eas_complete", "df_eur_complete", "df_sas_complete", 
                "df_male_complete", "df_female_complete", "meta_sex", "meta_subpop")
  
  
  ## pval srmsd
  # causal indices = causal_indexes
  load(paste0('rep-', rep_num, '/simtrait.RData'))

  
  # inflation values, srmsd, aucpr
  infl_pvals <- numeric()
  srmsd_vals <- numeric()
  auc_vals <- numeric()
  
  for (file in file_names) {
    print(file)
    file <- get(file)
    infl_pval <- pval_infl(file$p.value)
    infl_pvals <- c(infl_pvals, infl_pval)
    
    srmsd <- pval_srmsd(file$p.value, causal_indexes) 
    srmsd_vals <- c(srmsd_vals, srmsd)
    
    auc <- pval_aucpr(file$p.value, causal_indexes, curve = FALSE)
    auc_vals <- c(auc_vals, auc)
  }

  ## create dataframe for evaluation metrics:
  analysis <- c("joint", "afr", "amr", "eas", "eur", "sas", "male", "female", "sex-meta", "subpop-meta")
  df <- data.frame(analysis, infl_pvals, srmsd_vals, auc_vals)
  df$rep <- rep_num
  combined_df = rbind(combined_df, df)
}

rownames(combined_df) <- NULL
write.table(combined_df, paste0("eval/eval_tables_", rep, ".txt" ),
            col.names = TRUE, row.names = FALSE, quote = FALSE)

