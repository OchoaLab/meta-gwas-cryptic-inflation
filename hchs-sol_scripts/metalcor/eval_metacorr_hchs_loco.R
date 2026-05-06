#!/usr/bin/env Rscript
# Compute meta-corr LOCO inflation factors for HCHS/SOL
# Reads existing inflation_factor_loco.txt and adds metacorr_loco_lambda column

library(tidyverse)
library(simtrait)

library(metalcor)

saige_loco_dir <- "/home/tt207/pro00108518/hchs-sol/Ia/cryptic-relatedness/saige_loco"

# 33 quantitative traits (from combine_chrom_loco.q)
traits <- c("HEIGHT", "LABA2", "LOG_LABA75", "LOG_SLPA54", "LOG_ANTA4",
            "LOG_LABA66", "LOG_LABA68", "LOG_LABA69", "LOG_ANTA10A", "LOG_ANTA10B",
            "LOG_SBPA5", "LOG_SBPA6", "LOG_INSULIN_FAST", "LOG_WAIST_HIP",
            "LOG_LABA70", "LOG_LABA76", "LOG_LABA67", "LOG_LABA101", "LOG_LABA91",
            "LOG_INSULIN_OGTT", "LOG_LABA1", "LABA10", "LABA11", "LABA12",
            "LABA13", "LABA14", "LOG_LABA3", "LOG_LABA9", "LOG_LABA74",
            "LOG_LABA102", "LOG_LABA103", "LOG_LABA82", "LOG_BMI")

results <- data.frame()

for (trait in traits) {
  cat("Processing:", trait, "\n")

  male_file <- paste0(saige_loco_dir, "/sex/saige_output_male_", trait, "_loco.txt")
  female_file <- paste0(saige_loco_dir, "/sex/saige_output_female_", trait, "_loco.txt")

  # Skip if files don't exist
  if (!file.exists(male_file) || !file.exists(female_file)) {
    warning(paste("Skipping", trait, "- LOCO sex-stratified files not found"))
    next
  }

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

# Merge with existing LOCO inflation data
existing <- read.table("/home/tt207/pro00108518/hchs-sol/Ia/cryptic-relatedness/inflation_factor_loco.txt", header = TRUE)
df_out <- merge(existing, results, by = "trait")

out_file <- "/home/tt207/cryptic-relatedness/hchs-sol-inflation_factor_loco_metacorr.txt"
write.table(df_out, out_file, col.names = TRUE, row.names = FALSE, quote = FALSE)
cat("Wrote", out_file, "\n")
