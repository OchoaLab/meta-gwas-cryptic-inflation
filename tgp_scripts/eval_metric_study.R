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
  df_group1 = read.table(paste0('rep-', rep_num, '/saige_output_group1.txt'), header = TRUE)
  df_group2 = read.table(paste0('rep-', rep_num, '/saige_output_group2.txt'), header = TRUE)

  # meta
  meta_study <- read.table(paste0("METAL/substudy/output_substudy_", rep_num, "1.txt"), sep = "\t", stringsAsFactors=FALSE, quote = "", header = TRUE) %>% 
    separate(MarkerName, c("CHR", "POS")) %>% mutate(CHR = as.numeric(CHR), POS = as.numeric(POS)) %>% arrange(CHR, POS)  %>% dplyr::rename(p.value = P.value)

  # make sure each subanalyses contains ALL snps
  df_group1_complete = merge(all_snps, df_group1, by = c("CHR", "POS"), all.x = TRUE) %>% arrange(CHR, POS)
  df_group2_complete = merge(all_snps, df_group2, by = c("CHR", "POS"), all.x = TRUE) %>% arrange(CHR, POS)

  file_names = c( "df_group1_complete", "df_group2_complete", "meta_study")
  
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
  analysis <- c("group1", "group2", "study-meta")
  df <- data.frame(analysis, infl_pvals, srmsd_vals, auc_vals)
  df$rep <- rep_num
  combined_df = rbind(combined_df, df)
}

rownames(combined_df) <- NULL
write.table(combined_df, paste0("eval/eval_tables_group_", rep, ".txt" ),
            col.names = TRUE, row.names = FALSE, quote = FALSE)

