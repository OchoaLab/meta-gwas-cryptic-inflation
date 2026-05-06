#!/usr/bin/env Rscript
# Reads existing inflation_factor_data.txt and adds metacorr_lambda column

library(tidyverse)
library(simtrait)

library(metalcor)

saige_sex_dir <- "/home/tt207/pro00108518/t2d-samafs/study2/exome_chip/cryptic-relatedness/saige/sex"

# 20 quantitative traits + t2d binary (same list as inflation.Rmd)
traits <- c("height", "LOG_a2h_ins", "LOG_creatinine", "LOG_adiponectin",
            "LOG_leptin", "LOG_chol", "LOG_ldl", "LOG_hdl", "LOG_tg",
            "LOG_bmi", "LOG_hipc", "LOG_waistc", "LOG_whr", "LOG_dbp",
            "LOG_cystatin_c", "t2d",
            "LOG_fast_glu", "LOG_sbp", "LOG_fast_ins", "LOG_a2h_glu", "LOG_weight")

results <- data.frame()

for (trait in traits) {
  cat("Processing:", trait, "\n")

  # t2d binary uses different naming: saige_output_{sex}_{trait}_trait_age.txt
  if (trait == "t2d") {
    male_file <- paste0(saige_sex_dir, "/saige_output_", trait, "_male_t2d_age.txt")
    female_file <- paste0(saige_sex_dir, "/saige_output_", trait, "_female_t2d_age.txt")
  } else {
    male_file <- paste0(saige_sex_dir, "/saige_output_", trait, "_male_trait_age.txt")
    female_file <- paste0(saige_sex_dir, "/saige_output_", trait, "_female_trait_age.txt")
  }

  df_male <- read.table(male_file, header = TRUE)
  df_female <- read.table(female_file, header = TRUE)

  # Binary trait: N = N_case + N_ctrl
  if (trait == "t2d" && "N_case" %in% colnames(df_male)) {
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
  metacorr_lambda <- pval_infl(obj_metacorr$assoc$p)

  cat("  metacorr_lambda:", metacorr_lambda, "\n")

  results <- rbind(results, data.frame(
    trait = trait,
    metacorr_lambda = metacorr_lambda,
    stringsAsFactors = FALSE
  ))
}

# Read existing inflation factor data and merge
existing <- read.table("/home/tt207/pro00108518/t2d-samafs/study2/exome_chip/cryptic-relatedness/inflation_factor_data.txt", header = TRUE)
df_out <- merge(existing, results, by = "trait")

out_file <- "/home/tt207/cryptic-relatedness/samafs_inflation_factor_data_metacorr.txt"
write.table(df_out, out_file, col.names = TRUE, row.names = FALSE, quote = FALSE)
cat("Wrote", out_file, "\n")
