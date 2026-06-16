library(tidyverse)
library(genio)
library(optparse)

# Build SAIGE covariate files 

option_list <- list(
  make_option(c("-s", "--simulation"), type = "character", default = "sim1_h08",
              help = "sim folder name (sim1_h08, sim2_h08, sim3_h08, sim4_h08)"),
  make_option(c("-f", "--filename"), type = "character", default = NA,
              help = "plink filename prefix without ext (e.g. 30G_3000n_5000causal_500000m)"),
  make_option(c("-c", "--covar"), type = "character", default = NA,
              help = "merged covar file basename in rep dir (e.g. 30G_covar_3000n_5000causal_500000m_fes.txt)"),
  make_option(c("-n", "--num"), type = "character", default = "1",
              help = "rep number")
)
opt <- parse_args(OptionParser(option_list = option_list))
simulation <- opt$simulation
filename   <- opt$filename
covar_in   <- opt$covar
rep_num    <- opt$num

dir     <- "/hpc/dctrl/tt207/meta_analysis_aim/"
rep_dir <- paste0(dir, simulation, "/rep", rep_num, "/")
setwd(rep_dir)

print(paste("rep_dir:", rep_dir))
print(paste("covar_in:", covar_in))
print(paste("filename:", filename))

# merged covar (famid iid sex trait) written by sim*_5000causal.R
data <- read.table(covar_in, header = TRUE)

write_split_covar <- function(subdir, suffix) {
  prefix <- if (nzchar(suffix)) paste0(filename, "_", suffix) else filename
  rel    <- if (nzchar(subdir)) paste0(subdir, "/", prefix) else prefix

  grm <- read_grm(rel)
  eig <- read_eigenvec(rel)

  d <- data[ match(grm$fam$id, data$iid), ]
  d$PCs <- eig$eigenvec   # matrix column -> unpacks as PCs.1..PCs.K on write

  out <- d %>% select(famid, id = iid, trait, sex, PCs)
  out_path <- if (nzchar(subdir))
    paste0(subdir, "/covar_saige_", prefix, "_quant.txt")
  else
    paste0("covar_saige_", prefix, "_quant.txt")

  write.table(out, out_path,
              col.names = TRUE, row.names = FALSE, quote = FALSE, sep = " ")
  print(paste("wrote", out_path))
}

# all
write_split_covar("", "")
# sex
write_split_covar("sex", "male")
write_split_covar("sex", "female")
# subpop
write_split_covar("subpop", "S1")
write_split_covar("subpop", "S2")
write_split_covar("subpop", "S3")
