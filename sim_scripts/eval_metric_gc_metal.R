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
  # meta binary traits
  meta_sex <- read.table(paste0("./METAL/", simulation, "/output_sex_gc_", rep_num, "1.txt"), sep = "\t", stringsAsFactors=FALSE, quote = "", header = TRUE)
  meta_sex_binary_gc = merge(meta_sex, all_snps, by.x = "MarkerName", by.y = "MarkerID", all.y = TRUE) %>% dplyr::rename(p.value = 'P.value') %>% arrange(MarkerName)

  meta_subpop <- read.table(paste0("./METAL/", simulation, "/output_subpop_gc_", rep_num, "1.txt"), sep = "\t", stringsAsFactors=FALSE, quote = "", header = TRUE)
  meta_subpop_binary_gc = merge(meta_subpop, all_snps, by.x = "MarkerName", by.y = "MarkerID", all.y = TRUE) %>% dplyr::rename(p.value = 'P.value')  %>% arrange(MarkerName)
  
  # meta quant traits
  meta_sex <- read.table(paste0("./METAL/", simulation, "/output_sex_gc_", rep_num, "1.txt"), sep = "\t", stringsAsFactors=FALSE, quote = "", header = TRUE)
  meta_sex_quant_gc = merge(meta_sex, all_snps, by.x = "MarkerName", by.y = "MarkerID", all.y = TRUE) %>% dplyr::rename(p.value = 'P.value') %>% arrange(MarkerName)
  
  # causal indices
  file_temp = sub("^[^_]*_", "", file_name)
  if (sim == "sim1") {
    causal_id = read.table(paste0("./", simulation, '/rep', rep_num, "/1G_causal_id_", file_temp, ".txt"), header = TRUE)
    meta_subpop <- read.table(paste0("./METAL/", simulation, "/output_subpop_plink_quant_gc_", rep_num, "1.txt"), sep = "\t", stringsAsFactors=FALSE, quote = "", header = TRUE)
    meta_subpop_quant_gc = merge(meta_subpop, all_snps, by.x = "MarkerName", by.y = "MarkerID", all.y = TRUE) %>% dplyr::rename(p.value = 'P.value')  %>% arrange(MarkerName)
    
  } else {
    causal_id = read.table(paste0("./", simulation, '/rep', rep_num, "/30G_causal_id_", file_temp, "_fes.txt"), header = TRUE)
    meta_subpop <- read.table(paste0("./METAL/", simulation, "/output_subpop_quant_gc_", rep_num, "1.txt"), sep = "\t", stringsAsFactors=FALSE, quote = "", header = TRUE)
    meta_subpop_quant_gc = merge(meta_subpop, all_snps, by.x = "MarkerName", by.y = "MarkerID", all.y = TRUE) %>% dplyr::rename(p.value = 'P.value')  %>% arrange(MarkerName)

  }

  
  file_names = c("meta_sex_binary_gc", "meta_sex_quant_gc", "meta_subpop_binary_gc", "meta_subpop_quant_gc")
  
  
  # inflation values, srmsd, aucpr
  infl_pvals_gc <- numeric()
  srmsd_vals <- numeric()
  auc_vals <- numeric()
  
  for (file in file_names) {
    print(file)
    file <- get(file)
    infl_pval_gc <- pval_infl(file$p.value)
    infl_pvals_gc <- c(infl_pvals_gc, infl_pval_gc)
    
    srmsd <- pval_srmsd(file$p.value, causal_id$x) 
    srmsd_vals <- c(srmsd_vals, srmsd)
    
    auc <- pval_aucpr(file$p.value, causal_id$x, curve = FALSE)
    auc_vals <- c(auc_vals, auc)
  }

  ## create dataframe for evaluation metrics:
  analysis <- c("sex-meta-binary-gc", "sex-meta-quant-gc", "subpop-meta-binary-gc", "subpop-meta-quant-gc")
  df <- data.frame(analysis, infl_pvals_gc, srmsd_vals, auc_vals)
  df$rep <- rep_num
  combined_df = rbind(combined_df, df)
  
  
}

rownames(combined_df) <- NULL
write.table(combined_df, paste0("./eval_tables/", simulation, "_1_20_GC.txt" ),
            col.names = TRUE, row.names = FALSE, quote = FALSE)

