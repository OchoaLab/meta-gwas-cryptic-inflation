library(tidyverse)
library(simtrait)
library(optparse) 

setwd('/hpc/group/ochoalab/tt207/meta_analysis_aim')
# terminal inputs
option_list = list(
  make_option(c( "-s", "--simulation"), type = "character", default = 'sim1', 
              help = "simulation: sim1, sim2, sim3, sim4", metavar = "character"),
  make_option(c( "-f", "--filename"), type = "character", default = NA, 
              help = "filename/plink file", metavar = "character"))

opt_parser <- OptionParser(option_list = option_list)
opt <- parse_args(opt_parser)
# get values
simulation <- opt$simulation # sim1
file_name <- opt$filename # 1G_3000n_100causal_500000m 
sim = sub("_.*", "", simulation)
# create a list of all snps, since some snps are removed during saige
MarkerID = 1:500000
POS = MarkerID
CHR = 1
all_snps = cbind(CHR, POS, MarkerID) %>% as.data.frame()

# iterate for the 10 replicates
combined_df <- data.frame()
for (rep_num in 1:20) {
  print(rep_num)
  # load subpop files
  df_S1 = read.table(paste0("./", simulation, '/rep', rep_num, "/subpop/saige_output_", file_name, "_S1_new.txt"), header = TRUE)
  df_S2 = read.table(paste0("./", simulation, '/rep', rep_num, "/subpop/saige_output_", file_name, "_S2_new.txt"), header = TRUE)
  df_S3 = read.table(paste0("./", simulation, '/rep', rep_num, "/subpop/saige_output_", file_name, "_S3_new.txt"), header = TRUE)
  
  meta_subpop <- read.table(paste0("./METAL/", simulation, "/output_subpop_", rep_num, "1.txt"), sep = "\t", stringsAsFactors=FALSE, quote = "", header = TRUE)
  df_meta_subpop = merge(meta_subpop, all_snps, by.x = "MarkerName", by.y = "MarkerID", all.y = TRUE) %>% dplyr::rename(p.value = 'P.value')  %>% arrange(MarkerName)
  
  # make sure each subanalyses contains ALL snps
  df_S1_complete = merge(all_snps, df_S1, by = c("CHR", "POS", "MarkerID"), all.x = TRUE) %>% arrange(MarkerID)
  df_S2_complete = merge(all_snps, df_S2, by = c("CHR", "POS", "MarkerID"), all.x = TRUE) %>% arrange(MarkerID)
  df_S3_complete = merge(all_snps, df_S3, by = c("CHR", "POS", "MarkerID"), all.x = TRUE) %>% arrange(MarkerID)
 
  file_names = c("df_S1_complete", "df_S2_complete",
                "df_S3_complete", "df_meta_subpop")
  
  
  ## pval srmsd
  # causal indices
  file_temp = sub("^[^_]*_", "", file_name)

  causal_id = read.table(paste0("./", simulation, '/rep', rep_num, "/30G_causal_id_", file_temp, "_fes.txt"), header = TRUE)

  
  # inflation values, srmsd, aucpr
  infl_pvals <- numeric()
  srmsd_vals <- numeric()
  auc_vals <- numeric()
  
  for (file in file_names) {
    print(file)
    file <- get(file)
    infl_pval <- pval_infl(file$p.value)
    infl_pvals <- c(infl_pvals, infl_pval)
    
    srmsd <- pval_srmsd(file$p.value, causal_id$x) 
    srmsd_vals <- c(srmsd_vals, srmsd)
    
    auc <- pval_aucpr(file$p.value, causal_id$x, curve = FALSE)
    auc_vals <- c(auc_vals, auc)
  }

  ## create dataframe for evaluation metrics:
  analysis <- c("S1", "S2", "S3", "subpop-meta")
  df <- data.frame(analysis, infl_pvals, srmsd_vals, auc_vals)
  df$rep <- rep_num
  combined_df = rbind(combined_df, df)
}

rownames(combined_df) <- NULL
write.table(combined_df, paste0("./eval_tables/", simulation, "_1_20_subpop.txt" ),
            col.names = TRUE, row.names = FALSE, quote = FALSE)

