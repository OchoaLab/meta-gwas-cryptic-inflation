#!/usr/bin/env Rscript
# Compute meta-corr inflation factors for HCHS/SOL (non-LOCO)
# Reads existing inflation_factor_data.txt and adds metacorr_lambda column

library(tidyverse)
library(simtrait)

library(metalcor)

saige_dir <- "/hpc/dctrl/tt207/meta_analysis_aim/hchs-sol/saige"

# 34 quantitative traits (same list as hchs-sol inflation.Rmd)
traits <- c("LOG_LABA68", "LOG_LABA69", "LOG_ANTA4", "LOG_LABA66", "LOG_BMI",
            "LOG_ANTA10A", "LOG_ANTA10B", "LOG_SBPA5", "LOG_SBPA6", "LOG_INSULIN_FAST",
            "HEIGHT", "LOG_WAIST_HIP", "LOG_LABA70", "LOG_LABA76", "LOG_LABA67",
            "LOG_LABA101", "LOG_LABA91", "LOG_LABA66", "LOG_INSULIN_OGTT", "LOG_LABA1",
            "LABA10", "LABA11", "LABA12", "LABA13", "LABA14",
            "LABA2", "LOG_LABA3", "LOG_LABA9", "LOG_LABA74", "LOG_LABA75",
            "LOG_LABA102", "LOG_LABA103", "LOG_LABA82", "LOG_SLPA54")

results <- data.frame()

for (trait in traits) {
  cat("Processing:", trait, "\n")
  
  male_file <- paste0(saige_dir, "/saige_output_", trait, "_male.txt")
  female_file <- paste0(saige_dir, "/saige_output_", trait, "_female.txt")
  
  df_male <- read.table(male_file, header = TRUE)
  df_female <- read.table(female_file, header = TRUE)
  
  study_male <- df_male %>%
    dplyr::select(id = MarkerID, chr = CHR, pos = POS, beta = BETA, se = SE, n = N)
  study_female <- df_female %>%
    dplyr::select(id = MarkerID, chr = CHR, pos = POS, beta = BETA, se = SE, n = N)
  
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
existing <- read.table("/hpc/dctrl/tt207/meta_analysis_aim/hchs-sol/inflation_factor_data.txt", header = TRUE)
df_out <- merge(existing, results, by = "trait")

out_file <- "/hpc/dctrl/tt207/meta_analysis_aim/hchs-sol/hchs-sol-inflation_factor_data_metacorr.txt"
write.table(df_out, out_file, col.names = TRUE, row.names = FALSE, quote = FALSE)
cat("Wrote", out_file, "\n")
