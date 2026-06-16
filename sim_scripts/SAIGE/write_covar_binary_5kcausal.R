library(tidyverse)
library(genio)
library(optparse)

# Build SAIGE binary-trait covariate files for the 5000causal revision.
# Per cohort (all / sex-stratified / subpop-stratified), reads the existing continuous covar

option_list <- list(
  make_option(c("-s", "--simulation"), type = "character", default = "sim1_h08"),
  make_option(c("-f", "--filename"),   type = "character", default = NA,
              help = "plink filename prefix (e.g. 30G_3000n_5000causal_500000m)"),
  make_option(c("-c", "--covar"),      type = "character", default = NA,
              help = "merged covar file basename in rep dir"),
  make_option(c("-n", "--num"),        type = "character", default = "1")
)
opt <- parse_args(OptionParser(option_list = option_list))
simulation <- opt$simulation
filename   <- opt$filename
covar_in   <- opt$covar
rep_num    <- opt$num

dir     <- "/hpc/dctrl/tt207/meta_analysis_aim/"
rep_dir <- paste0(dir, simulation, "/rep", rep_num, "/")
setwd(rep_dir)

print(paste("rep_dir:", rep_dir, "covar_in:", covar_in, "filename:", filename))

# merged covar (famid iid sex trait) written by sim*_5000causal.R
data <- read.table(covar_in, header = TRUE)

write_split_covar_binary <- function(subdir, suffix) {
  prefix <- if (nzchar(suffix)) paste0(filename, "_", suffix) else filename
  rel    <- if (nzchar(subdir)) paste0(subdir, "/", prefix) else prefix

  grm <- read_grm(rel)
  eig <- read_eigenvec(rel)

  d <- data[ match(grm$fam$id, data$iid), ]
  d$PCs <- eig$eigenvec

  # dichotomize continuous trait at within-cohort median for binary analysis
  med <- stats::median(d$trait, na.rm = TRUE)
  d$trait <- ifelse(d$trait >= med, 1L, 0L)

  out <- d %>% select(famid, id = iid, trait, sex, PCs)
  out_path <- if (nzchar(subdir))
    paste0(subdir, "/covar_saige_", prefix, "_fes.txt")
  else
    paste0("covar_saige_", prefix, "_fes.txt")

  write.table(out, out_path,
              col.names = TRUE, row.names = FALSE, quote = FALSE, sep = " ")
  print(paste("wrote", out_path))
}

# all 6 covar files for one rep (joint + 2 sex + 3 subpop)
write_split_covar_binary("", "")
write_split_covar_binary("sex", "male")
write_split_covar_binary("sex", "female")
write_split_covar_binary("subpop", "S1")
write_split_covar_binary("subpop", "S2")
write_split_covar_binary("subpop", "S3")
