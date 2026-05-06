#!/usr/bin/env Rscript
# Compute meta-corr LOCO inflation factors for SAMAFS
# Reads existing inflation_factor_loco.txt and adds metacorr_loco_lambda column

library(tidyverse)
library(simtrait)

library(metalcor)

saige_loco_dir <- "/home/tt207/pro00108518/t2d-samafs/study2/exome_chip/cryptic-relatedness/saige_loco"

# 20 quantitative traits + t2d binary
quant_traits <- c("height", "LOG_a2h_ins", "LOG_creatinine", "LOG_adiponectin",
                  "LOG_leptin", "LOG_ldl", "LOG_hdl", "LOG_tg", "LOG_chol",
                  "LOG_bmi", "LOG_hipc", "LOG_waistc", "LOG_whr", "LOG_dbp",
                  "LOG_cystatin_c", "LOG_fast_glu", "LOG_sbp", "LOG_fast_ins",
                  "LOG_a2h_glu", "LOG_weight")

results <- data.frame()

for (trait in quant_traits) {
  cat("Processing:", trait, "\n")

  male_file <- paste0(saige_loco_dir, "/sex/saige_output_male_", trait, "_loco.txt")
  female_file <- paste0(saige_loco_dir, "/sex/saige_output_female_", trait, "_loco.txt")

  df_male <- read.table(male_file, header = TRUE)
  df_female <- read.table(female_file, header = TRUE)

  study_male <- df_male %>%
    dplyr::select(id = MarkerID, chr = CHR, pos = POS, beta = BETA, se = SE, n = N)
  study_female <- df_female %>%
    dplyr::select(id = MarkerID, chr = CHR, pos = POS, beta = BETA, se = SE, n = N)

  obj_metacorr <- metalcor(list(study_female, study_male), median = TRUE)
  metacorr_loco_lambda <- pval_infl(obj_metacorr$assoc$p)

  cat("  metacorr_loco_lambda:", metacorr_loco_lambda, "\n")

  results <- rbind(results, data.frame(
    trait = trait,
    metacorr_loco_lambda = metacorr_loco_lambda,
    stringsAsFactors = FALSE
  ))
}

# t2d (binary) — different file naming
cat("Processing: t2d\n")

male_file <- paste0(saige_loco_dir, "/sex/saige_output_male_t2d_loco.txt")
female_file <- paste0(saige_loco_dir, "/sex/saige_output_female_t2d_loco.txt")

df_male <- read.table(male_file, header = TRUE)
df_female <- read.table(female_file, header = TRUE)

if ("N_case" %in% colnames(df_male)) {
  study_male <- df_male %>%
    mutate(N = N_case + N_ctrl) %>%
    dplyr::select(id = MarkerID, chr = CHR, pos = POS, beta = BETA, se = SE, n = N)
  study_female <- df_female %>%
    mutate(N = N_case + N_ctrl) %>%
    dplyr::select(id = MarkerID, chr = CHR, pos = POS, beta = BETA, se = SE, n = N)
} else {
  study_male <- df_male %>%
    dplyr::select(id = MarkerID, chr = CHR, pos = POS, beta = BETA, se = SE, n = N)
  study_female <- df_female %>%
    dplyr::select(id = MarkerID, chr = CHR, pos = POS, beta = BETA, se = SE, n = N)
}

obj_metacorr <- metalcor(list(study_female, study_male), median = TRUE)
metacorr_loco_lambda <- pval_infl(obj_metacorr$assoc$p)
cat("  metacorr_loco_lambda:", metacorr_loco_lambda, "\n")

results <- rbind(results, data.frame(
  trait = "t2d",
  metacorr_loco_lambda = metacorr_loco_lambda,
  stringsAsFactors = FALSE
))

# Merge with existing LOCO inflation data
existing <- read.table("/home/tt207/pro00108518/t2d-samafs/study2/exome_chip/cryptic-relatedness/inflation_factor_loco.txt", header = TRUE)
df_out <- merge(existing, results, by = "trait")

out_file <- "/home/tt207/cryptic-relatedness/samafs_inflation_factor_loco_metacorr.txt"
write.table(df_out, out_file, col.names = TRUE, row.names = FALSE, quote = FALSE)
cat("Wrote", out_file, "\n")
