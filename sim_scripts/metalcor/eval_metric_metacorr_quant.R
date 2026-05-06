#!/usr/bin/env Rscript
# Produces eval table: eval_tables/{simulation}_1_20_metacorr_quant.txt

library(tidyverse)
library(simtrait)
library(optparse)

library(metalcor)

setwd('/hpc/dctrl/tt207/meta_analysis_aim')

option_list = list(
  make_option(c("-s", "--simulation"), type = "character", default = 'sim1_h08',
              help = "simulation: sim1_h08, sim2_h08, sim3_h08, sim4_h08", metavar = "character"),
  make_option(c("-f", "--filename"), type = "character", default = NA,
              help = "filename/plink file (e.g. 1G_3000n_100causal_500000m)", metavar = "character"),
  make_option(c("-m", "--median"), type = "character", default = "TRUE",
              help = "use median-based correlation estimation (TRUE or FALSE)", metavar = "character"))

opt_parser <- OptionParser(option_list = option_list)
opt <- parse_args(opt_parser)
simulation <- opt$simulation
file_name <- opt$filename
use_median <- as.logical(opt$median)
sim <- sub("_.*", "", simulation)

# All SNP IDs (500k), used to ensure complete vectors for eval metrics
MarkerID <- 1:500000
POS <- MarkerID
CHR <- 1
all_snps <- cbind(CHR, POS, MarkerID) %>% as.data.frame()

read_table_check <- function(file_path) {
  tryCatch({
    read.table(file_path, header = TRUE)
  }, error = function(e) {
    warning(paste("Error reading file:", file_path, "->", e$message))
    NULL
  })
}

method_suffix <- if (use_median) "_median" else "_mean"
r_dir <- paste0("./eval_tables/R_matrices")
dir.create(r_dir, showWarnings = FALSE, recursive = TRUE)

combined_df <- data.frame()
for (rep_num in 1:20) {
  cat("Rep", rep_num, "\n")

  # Read sex-stratified SAIGE outputs (quantitative trait)
  df_male <- read_table_check(paste0("./", simulation, '/rep', rep_num,
                                     "/sex/saige_output_", file_name, "_male_quant.txt"))
  df_female <- read_table_check(paste0("./", simulation, '/rep', rep_num,
                                       "/sex/saige_output_", file_name, "_female_quant.txt"))

  if (is.null(df_male) || is.null(df_female)) {
    warning(paste("Skipping rep", rep_num, "- male or female data missing"))
    next
  }

  # Prepare inputs for meta_corr (rename to expected column names)
  study_female <- df_female %>%
    dplyr::select(id = MarkerID, chr = CHR, pos = POS, beta = BETA, se = SE, n = N)
  study_male <- df_male %>%
    dplyr::select(id = MarkerID, chr = CHR, pos = POS, beta = BETA, se = SE, n = N)

  # Run meta_corr (median-based correlation estimation)
  obj_metacorr <- metalcor(list(study_female, study_male), median = use_median)

  # Print and save estimated R matrix for this rep
  cat("  Estimated R:\n")
  print(obj_metacorr$R)
  r_file <- paste0(r_dir, "/", simulation, "_rep", rep_num, "_sex_quant", method_suffix, ".txt")
  write.table(obj_metacorr$R, r_file, col.names = TRUE, row.names = TRUE, quote = FALSE)

  # Merge with all_snps to ensure 500k rows (NAs for missing SNPs)
  df_meta_sex_corr <- data.frame(
    MarkerID = obj_metacorr$assoc$id,
    p.value  = obj_metacorr$assoc$p
  ) %>%
    merge(all_snps, by = "MarkerID", all.y = TRUE) %>%
    arrange(MarkerID)

  # Causal SNP indices
  file_temp <- sub("^[^_]*_", "", file_name)
  if (sim == "sim1") {
    causal_id <- read.table(paste0("./", simulation, '/rep', rep_num,
                                   "/1G_causal_id_", file_temp, ".txt"), header = TRUE)
  } else {
    causal_id <- read.table(paste0("./", simulation, '/rep', rep_num,
                                   "/30G_causal_id_", file_temp, "_fes.txt"), header = TRUE)
  }

  # Compute eval metrics (no GC correction)
  df_rep <- data.frame(
    analysis   = "sex-meta-corr",
    infl_pvals = pval_infl(df_meta_sex_corr$p.value),
    srmsd_vals = pval_srmsd(df_meta_sex_corr$p.value, causal_id$x),
    auc_vals   = pval_aucpr(df_meta_sex_corr$p.value, causal_id$x, curve = FALSE),
    rep        = rep_num
  )
  combined_df <- rbind(combined_df, df_rep)
}

rownames(combined_df) <- NULL
out_file <- paste0("./eval_tables/", simulation, "_1_20_metacorr_quant", method_suffix, ".txt")
write.table(combined_df, out_file, col.names = TRUE, row.names = FALSE, quote = FALSE)
cat("Wrote", out_file, "\n")
