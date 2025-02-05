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
  if (sim == "sim4"){
    df_all = read.table(paste0("./", simulation, '/rep', rep_num, '/saige_output.txt'), header = TRUE) 
    # load subpop files
    df_S1 = read.table(paste0("./", simulation, '/rep', rep_num, "/subpop/saige_output_", file_name, "_S1_new.txt"), header = TRUE)
    df_S2 = read.table(paste0("./", simulation, '/rep', rep_num, "/subpop/saige_output_", file_name, "_S2_new.txt"), header = TRUE)
    df_S3 = read.table(paste0("./", simulation, '/rep', rep_num, "/subpop/saige_output_", file_name, "_S3_new.txt"), header = TRUE)
    
    # read sex stratified analysis results
    df_male = read.table(paste0("./", simulation, '/rep', rep_num, "/sex/saige_output_", file_name, "_male.txt"), header = TRUE) 
    df_female = read.table(paste0("./", simulation, '/rep', rep_num, "/sex/saige_output_", file_name, "_female.txt"), header = TRUE) 
    
    # meta
    meta_sex <- read.table(paste0("./METAL/", simulation, "/output_sex_", rep_num, "1.txt"), sep = "\t", stringsAsFactors=FALSE, quote = "", header = TRUE)
    df_meta_sex = merge(meta_sex, all_snps, by.x = "MarkerName", by.y = "MarkerID", all.y = TRUE) %>% dplyr::rename(p.value = 'P.value') %>% arrange(MarkerName)
    
  } else {
    # for sim1, 2, 3
    df_all = read.table(paste0("./", simulation, '/rep', rep_num, '/saige_output_new.txt'), header = TRUE) 
    # load subpop files
    df_S1 = read.table(paste0("./", simulation, '/rep', rep_num, "/subpop/saige_output_", file_name, "_S1.txt"), header = TRUE)
    df_S2 = read.table(paste0("./", simulation, '/rep', rep_num, "/subpop/saige_output_", file_name, "_S2.txt"), header = TRUE)
    df_S3 = read.table(paste0("./", simulation, '/rep', rep_num, "/subpop/saige_output_", file_name, "_S3.txt"), header = TRUE)
    
    # read sex stratified analysis results
    df_male = read.table(paste0("./", simulation, '/rep', rep_num, "/sex/saige_output_", file_name, "_male_new.txt"), header = TRUE) 
    df_female = read.table(paste0("./", simulation, '/rep', rep_num, "/sex/saige_output_", file_name, "_female_new.txt"), header = TRUE) 
  
    # meta
    meta_sex <- read.table(paste0("./METAL/", simulation, "/output_sex_new_", rep_num, "1.txt"), sep = "\t", stringsAsFactors=FALSE, quote = "", header = TRUE)
    df_meta_sex = merge(meta_sex, all_snps, by.x = "MarkerName", by.y = "MarkerID", all.y = TRUE) %>% dplyr::rename(p.value = 'P.value') %>% arrange(MarkerName)
  }
  # same file inputs for all simulations
  meta_subpop <- read.table(paste0("./METAL/", simulation, "/output_subpop_", rep_num, "1.txt"), sep = "\t", stringsAsFactors=FALSE, quote = "", header = TRUE)
  df_meta_subpop = merge(meta_subpop, all_snps, by.x = "MarkerName", by.y = "MarkerID", all.y = TRUE) %>% dplyr::rename(p.value = 'P.value')  %>% arrange(MarkerName)
  
  # make sure each subanalyses contains ALL snps
  df_S1_complete = merge(all_snps, df_S1, by = c("CHR", "POS", "MarkerID"), all.x = TRUE) %>% arrange(MarkerID)
  df_S2_complete = merge(all_snps, df_S2, by = c("CHR", "POS", "MarkerID"), all.x = TRUE) %>% arrange(MarkerID)
  df_S3_complete = merge(all_snps, df_S3, by = c("CHR", "POS", "MarkerID"), all.x = TRUE) %>% arrange(MarkerID)
  df_male_complete = merge(all_snps, df_male, by = c("CHR", "POS", "MarkerID"), all.x = TRUE) %>% arrange(MarkerID)
  df_female_complete = merge(all_snps, df_female, by = c("CHR", "POS", "MarkerID"), all.x = TRUE) %>% arrange(MarkerID)
  df_all_complete = merge(all_snps, df_all, by = c("CHR", "POS", "MarkerID"), all.x = TRUE) %>% arrange(MarkerID)
  
  file_names = c("df_all_complete", "df_S1_complete", "df_S2_complete",
                "df_S3_complete", "df_male_complete", "df_female_complete", "df_meta_sex", "df_meta_subpop")
  
  
  ## pval srmsd
  # causal indices
  file_temp = sub("^[^_]*_", "", file_name)
  
  if (sim == "sim1") {
    causal_id = read.table(paste0("./", simulation, '/rep', rep_num, "/1G_causal_id_", file_temp, ".txt"), header = TRUE)
  } else {
    causal_id = read.table(paste0("./", simulation, '/rep', rep_num, "/30G_causal_id_", file_temp, "_fes.txt"), header = TRUE)
  }
  
  # inflation values, srmsd, aucpr
  infl_pvals <- numeric()
  infl_pvals_null <- numeric()
  infl_pvals_gc <- numeric()
  infl_pvals_gc_null <- numeric()
  srmsd_vals <- numeric()
  srmsd_vals_gc <- numeric()
  auc_vals <- numeric()
  auc_vals_gc <- numeric()
  
  for (file in file_names) {
    print(file)
    file <- get(file)
    infl_pval <- pval_infl(file$p.value)
    infl_pvals <- c(infl_pvals, infl_pval)
    
    infl_pval_null <- pval_infl(file$p.value[-causal_id$x])
    infl_pvals_null <- c(infl_pvals_null, infl_pval_null)
    
    infl_pval_gc <- pval_infl(pval_gc(file$p.value)$pvals)
    infl_pvals_gc <- c(infl_pvals_gc, infl_pval_gc)
    
    infl_pval_gc_null <- pval_infl(pval_gc(file$p.value)$pvals[-causal_id$x])
    infl_pvals_gc_null <- c(infl_pvals_gc, infl_pval_gc)
    
    srmsd <- pval_srmsd(file$p.value, causal_id$x) 
    srmsd_vals <- c(srmsd_vals, srmsd)
    
    srmsd_gc <- pval_srmsd(pval_gc(file$p.value)$pvals, causal_id$x) 
    srmsd_vals_gc <- c(srmsd_vals_gc, srmsd_gc)
    
    auc <- pval_aucpr(file$p.value, causal_id$x, curve = FALSE)
    auc_vals <- c(auc_vals, auc)
    
    # auc_gc <- pval_aucpr(pval_gc(file$p.value)$pvals, causal_id$x, curve = FALSE)
    # auc_vals_gc <- c(auc_vals_gc, auc_gc)
  }

  ## create dataframe for evaluation metrics:
  analysis <- c("joint", "S1", "S2", "S3", "male", "female", "sex-meta", "subpop-meta")
  df <- data.frame(analysis, infl_pvals, infl_pvals_null, infl_pvals_gc, infl_pval_gc_null, srmsd_vals, srmsd_vals_gc, auc_vals)
  df$rep <- rep_num
  combined_df = rbind(combined_df, df)
  
  # add new inflation factor to combined df
  
}

rownames(combined_df) <- NULL
write.table(combined_df, paste0("./eval_tables/", simulation, "_1_20_gc_binary.txt" ),
            col.names = TRUE, row.names = FALSE, quote = FALSE)

