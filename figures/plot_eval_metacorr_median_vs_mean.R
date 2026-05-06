library(tidyverse)
library(ggplot2)
library(gdata)
library(scales)
library(cowplot)
setwd('/hpc/dctrl/tt207/meta_analysis_aim/eval_tables')

read_metacorr <- function(trait) {
  # Sex-stratified
  sim1_med = read.table(paste0("sim1_h08_1_20_metacorr_", trait, "_median.txt"), header = TRUE)
  sim2_med = read.table(paste0("sim2_h08_1_20_metacorr_", trait, "_median.txt"), header = TRUE)
  sim3_med = read.table(paste0("sim3_h08_1_20_metacorr_", trait, "_median.txt"), header = TRUE)
  sim4_med = read.table(paste0("sim4_h08_1_20_metacorr_", trait, "_median.txt"), header = TRUE)

  sim1_mean = read.table(paste0("sim1_h08_1_20_metacorr_", trait, "_mean.txt"), header = TRUE)
  sim2_mean = read.table(paste0("sim2_h08_1_20_metacorr_", trait, "_mean.txt"), header = TRUE)
  sim3_mean = read.table(paste0("sim3_h08_1_20_metacorr_", trait, "_mean.txt"), header = TRUE)
  sim4_mean = read.table(paste0("sim4_h08_1_20_metacorr_", trait, "_mean.txt"), header = TRUE)

  # Subpop-stratified
  sim1_sp_med = read.table(paste0("sim1_h08_1_20_metacorr_subpop_", trait, "_median.txt"), header = TRUE)
  sim2_sp_med = read.table(paste0("sim2_h08_1_20_metacorr_subpop_", trait, "_median.txt"), header = TRUE)
  sim3_sp_med = read.table(paste0("sim3_h08_1_20_metacorr_subpop_", trait, "_median.txt"), header = TRUE)
  sim4_sp_med = read.table(paste0("sim4_h08_1_20_metacorr_subpop_", trait, "_median.txt"), header = TRUE)

  sim1_sp_mean = read.table(paste0("sim1_h08_1_20_metacorr_subpop_", trait, "_mean.txt"), header = TRUE)
  sim2_sp_mean = read.table(paste0("sim2_h08_1_20_metacorr_subpop_", trait, "_mean.txt"), header = TRUE)
  sim3_sp_mean = read.table(paste0("sim3_h08_1_20_metacorr_subpop_", trait, "_mean.txt"), header = TRUE)
  sim4_sp_mean = read.table(paste0("sim4_h08_1_20_metacorr_subpop_", trait, "_mean.txt"), header = TRUE)

  df_sex_med = gdata::combine(sim1_med, sim2_med, sim3_med, sim4_med)
  df_sex_med$source <- sub("_med$", "", df_sex_med$source)
  df_sex_med$method <- "Median"

  df_sex_mean = gdata::combine(sim1_mean, sim2_mean, sim3_mean, sim4_mean)
  df_sex_mean$source <- sub("_mean$", "", df_sex_mean$source)
  df_sex_mean$method <- "Mean"

  df_sp_med = gdata::combine(sim1_sp_med, sim2_sp_med, sim3_sp_med, sim4_sp_med)
  df_sp_med$source <- sub("_sp_med$", "", df_sp_med$source)
  df_sp_med$method <- "Median"

  df_sp_mean = gdata::combine(sim1_sp_mean, sim2_sp_mean, sim3_sp_mean, sim4_sp_mean)
  df_sp_mean$source <- sub("_sp_mean$", "", df_sp_mean$source)
  df_sp_mean$method <- "Mean"

  rbind(df_sex_med, df_sex_mean, df_sp_med, df_sp_mean)
}

df_binary <- read_metacorr("binary") %>% mutate(trait = "Binary")
df_quant  <- read_metacorr("quant")  %>% mutate(trait = "Quantitative")
df <- rbind(df_binary, df_quant)

lines_df <- data.frame(
  yintercept = c(0.95, 1.05, -0.01, 0.01),
  row_group = c("Inflation Factor", "Inflation Factor", "SRMSDp", "SRMSDp")
)

# Combined binary & quant trait figures; median vs mean
df_long2 <- rbind(
  read_metacorr("binary") %>% mutate(trait = "Binary"),
  read_metacorr("quant")  %>% mutate(trait = "Quantitative")
)

df_long2 <- pivot_longer(df_long2, cols = c(infl_pvals, srmsd_vals, auc_vals),
                         names_to = "metric", values_to = "value")

df_long2$method <- factor(df_long2$method, levels = c("Median", "Mean"))
df_long2$source <- factor(df_long2$source, levels = c("sim1", "sim2", "sim3", "sim4"))

df_long2 <- df_long2 %>%
  mutate(
    row_group = case_when(
      metric == "auc_vals" ~ "AUC",
      metric == "infl_pvals" ~ "Inflation Factor",
      metric == "srmsd_vals" ~ "SRMSDp"
    ),
    col_label = paste0(trait, "\n", analysis)
  )
df_long2$col_label <- factor(df_long2$col_label,
                             levels = c("Binary\nsex-meta-corr", "Binary\nsubpop-meta-corr",
                                        "Quantitative\nsex-meta-corr", "Quantitative\nsubpop-meta-corr"))
df_plot2 <- df_long2 %>%
  filter(
    (row_group == "AUC") |
    (row_group == "Inflation Factor" & value >= 0.95 & value <= 1.05) |
    (row_group == "SRMSDp" & value >= -0.01 & value <= 0.01)
  )

png('/hpc/group/ochoalab/tt207/meta_analysis_aim/plots/metacorr_median_vs_mean_combined.png',
    width = 28, height = 20, res = 300, units = 'in')
ggplot(df_plot2, aes(x = source, y = value, fill = method)) +
  geom_hline(data = lines_df, aes(yintercept = yintercept),
             color = "gray", linewidth = 1.5, linetype = "dashed") +
  geom_boxplot(width = 0.6, alpha = 0.6, size = 1.2) +
  labs(x = NULL, y = "Value") +
  theme_classic() +
  facet_grid(rows = vars(row_group), cols = vars(col_label), scales = "free_y") +
  scale_fill_manual(values = c("Median" = "#357EBD", "Mean" = "#D43F3A")) +
  theme(
    panel.spacing = unit(1, "lines"),
    strip.text = element_text(size = 24),
    axis.title = element_text(size = 24),
    legend.text = element_text(size = 24),
    axis.text = element_text(size = 20),
    legend.position = "bottom",
    legend.title = element_blank(),
    legend.key.size = unit(2.5, "lines"),
    panel.border = element_rect(colour = "black", fill = NA, linewidth = 1.5),
    panel.background = element_blank(),
    axis.line = element_line(linewidth = 1.5),
    plot.margin = margin(t = 36, r = 5, b = 5, l = 5)
  )
invisible(dev.off())
