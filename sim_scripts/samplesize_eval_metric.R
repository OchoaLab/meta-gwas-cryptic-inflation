library(tidyverse)
library(simtrait)

setwd('/hpc/group/ochoalab/tt207/meta_analysis_aim')

# METAL outputs are on a different filesystem root than the SAIGE outputs
metal_root <- '/hpc/dctrl/tt207/meta_analysis_aim/METAL'

# Evaluate sim4 across sample sizes N = 10000, 8000, 6000.
# Causal SNP indices are the same across subsets, so always read from sim4_10000.
N_list    <- c(10000, 8000, 6000, 4000, 2000)
rep_list  <- 1:5

# Full SNP list (SAIGE drops some, so we left-join to fill in NAs)
all_snps <- data.frame(CHR = 1, POS = 1:500000, MarkerID = 1:500000)

read_table_check <- function(file_path) {
  tryCatch(read.table(file_path, header = TRUE),
           error = function(e) {
             warning(paste("Error reading file:", file_path, "->", e$message))
             NULL
           })
}

combined_df <- data.frame()

for (N in N_list) {
  sim_dir   <- paste0('sim4_', N)
  file_name <- paste0('30G_', N, 'n_100causal_500000m')
  file_temp <- sub('^[^_]*_', '', file_name)   # "10000n_100causal_500000m"

  for (rep_num in rep_list) {
    cat('N =', N, ' rep =', rep_num, '\n')

    rep_dir <- paste0('./', sim_dir, '/rep', rep_num)

    # Joint (all samples)
    df_all    <- read_table_check(paste0(rep_dir, '/saige_output_quant.txt'))

    # Sex-stratified
    df_male   <- read_table_check(paste0(rep_dir, '/sex/saige_output_', file_name, '_male_quant.txt'))
    df_female <- read_table_check(paste0(rep_dir, '/sex/saige_output_', file_name, '_female_quant.txt'))

    # Meta analysis for sex
    meta_sex  <- read_table_check(paste0(metal_root, '/', sim_dir, '/output_sex_quant_', rep_num, '1.txt'))
    df_meta_sex <- if (!is.null(meta_sex)) {
      merge(meta_sex, all_snps, by.x = 'MarkerName', by.y = 'MarkerID', all.y = TRUE) %>%
        dplyr::rename(p.value = 'P.value') %>% arrange(MarkerName)
    } else NULL

    # Fill in missing SNPs
    complete_or_null <- function(df)
      if (!is.null(df)) merge(all_snps, df, by = c('CHR','POS','MarkerID'), all.x = TRUE) %>%
          arrange(MarkerID) else NULL

    df_all_complete    <- complete_or_null(df_all)
    df_male_complete   <- complete_or_null(df_male)
    df_female_complete <- complete_or_null(df_female)

    # Causal SNP ids: always from the N=10000 directory (same causal set)
    causal_fn <- paste0('./sim4_10000/rep', rep_num,
                        '/30G_causal_id_10000n_100causal_500000m_fes.txt')
    causal_id <- read.table(causal_fn, header = TRUE)

    # Metrics per analysis
    analyses <- list(joint        = df_all_complete,
                     male         = df_male_complete,
                     female       = df_female_complete,
                     `sex-meta`   = df_meta_sex)

    infl_pvals      <- numeric()
    infl_pvals_null <- numeric()
    srmsd_vals      <- numeric()
    auc_vals        <- numeric()

    for (nm in names(analyses)) {
      d <- analyses[[nm]]
      if (is.null(d)) {
        infl_pvals      <- c(infl_pvals,      NA)
        infl_pvals_null <- c(infl_pvals_null, NA)
        srmsd_vals      <- c(srmsd_vals,      NA)
        auc_vals        <- c(auc_vals,        NA)
        next
      }
      infl_pvals      <- c(infl_pvals,      pval_infl(d$p.value))
      infl_pvals_null <- c(infl_pvals_null, pval_infl(d$p.value[-causal_id$x]))
      srmsd_vals      <- c(srmsd_vals,      pval_srmsd(d$p.value, causal_id$x))
      auc_vals        <- c(auc_vals,        pval_aucpr(d$p.value, causal_id$x, curve = FALSE))
    }

    df <- data.frame(analysis  = names(analyses),
                     infl_pvals, infl_pvals_null,
                     srmsd_vals, auc_vals,
                     N         = N,
                     rep       = rep_num)
    combined_df <- rbind(combined_df, df)
  }
}

rownames(combined_df) <- NULL
write.table(combined_df, './eval_tables/sim4_N10000_8000_6000_4000_2000quant.txt',
            col.names = TRUE, row.names = FALSE, quote = FALSE)
