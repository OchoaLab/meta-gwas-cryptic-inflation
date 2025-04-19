library(tidyverse)
library(ggplot2)
library(gdata)
library(RColorBrewer)
library(ggsci)
library(scales)
setwd('/hpc/dctrl/tt207/meta_analysis_aim/eval_tables')

# binary
sim1 = read.table("sim1_h08_1_20_gc_binary.txt", header = TRUE)
sim2 = read.table("sim2_h08_1_20_gc_binary.txt", header = TRUE)
sim3 = read.table("sim3_h08_1_20_gc_binary.txt", header = TRUE)
sim4 = read.table("sim4_h08_1_20_gc_binary.txt", header = TRUE)


df = gdata::combine(sim1, sim2, sim3, sim4) 

df_long = pivot_longer(df, cols = c(infl_pvals, infl_pvals_gc, 
                                    srmsd_vals, srmsd_vals_gc, auc_vals, auc_vals_gc),
                                    names_to = "metric", values_to = "value") 

df_long$analysis <- factor(df_long$analysis, 
                           levels = c("joint", "sex-meta", "subpop-meta", "male", "female", 
                                      "S1", "S2", "S3"))
df_long$source <- factor(df_long$source, levels = unique(df_long$source))

# extract wanted evaluation metrics and rename for figure
main = df_long %>% 
  mutate(eval_metric = ifelse(metric == "auc_vals", "auc",
                              ifelse(metric %in%  c("infl_pval_gc_null", "infl_pvals", "infl_pvals_gc", "infl_pvals_null"), "inflation factor",
                                     ifelse(metric %in% c("srmsd_vals", "srmsd_vals_gc"), "srmsd", metric)))) %>% 
  filter(!(analysis %in% c("S1", "S2", "S3", "male", "female")) & !(metric %in% c( "infl_pvals_null"))) 


# regroup for facet wrap
main_grouped <- main %>%
  mutate(row_group = case_when(
    metric %in% c("auc_vals", "auc_vals_gc") ~ "AUC",
    metric %in% c("infl_pvals", "infl_pvals_gc") ~ "Inflation Factor",
    metric %in% c("srmsd_vals", "srmsd_vals_gc") ~ "SRMSDp",
    TRUE ~ metric
  )) %>%
  mutate(metric_short = case_when(
    metric %in% c("auc_vals", "infl_pvals", "srmsd_vals") ~ "Original",
    metric %in% c("auc_vals_gc", "infl_pvals_gc", "srmsd_vals_gc") ~ "GC-corrected",
    TRUE ~ metric
  ),
  metric_short = factor(metric_short, levels = c("Original", "GC-corrected"))
  )

facet_title_color <- "#D3D3D380"
lines_df <- data.frame(
  yintercept = c(0.95, 1.05, -0.01, 0.01),
  row_group = c("Inflation Factor", "Inflation Factor", "SRMSDp", "SRMSDp")
)

png( '/hpc/group/ochoalab/tt207/meta_analysis_aim/plots/main_analyses_binary_gc.png', width=14, height=20, res=300, units = 'in')
ggplot(main_grouped , aes(x = source, y = value, fill = analysis)) +
  geom_hline(data = lines_df, aes(yintercept = yintercept), color = "gray", linewidth = 1.5, linetype = "dashed") +
  geom_boxplot(width = 0.6, alpha = 0.5, size = 1.2) +
  labs(x = "Simulation", y = "Value", fill = "Subset") + 
  theme_bw() + 
  facet_grid(rows = vars(row_group), cols = vars(metric_short), scales = "free_y") +
  scale_fill_nejm() + 
  theme(
    strip.background = element_rect(fill = facet_title_color, size = 1.5),
    panel.spacing = unit(1, "lines"), 
    strip.text = element_text(size = 36),
    axis.title = element_text(size = 27),
    legend.text = element_text(size = 28),
    axis.text = element_text(size = 26),
    legend.position = "top",
    legend.title = element_blank(),
    legend.key.size = unit(3, "lines"),
    panel.border = element_rect(linewidth = 1.5),
    axis.line = element_line(linewidth = 1.5)
  ) +
  guides(color = guide_legend(override.aes = list(size = 25)))
invisible( dev.off() )
############### quantitative traits
sim1 = read.table("sim1_h08_1_20_gc_quant.txt", header = TRUE)
sim2 = read.table("sim2_h08_1_20_gc_quant.txt", header = TRUE)
sim3 = read.table("sim3_h08_1_20_gc_quant.txt", header = TRUE)
sim4 = read.table("sim4_h08_1_20_gc_quant.txt", header = TRUE)

df = gdata::combine(sim1, sim2, sim3, sim4) 

df_long = pivot_longer(df, cols = c(infl_pvals, infl_pvals_gc, 
                                    srmsd_vals, srmsd_vals_gc, auc_vals, auc_vals_gc),
                       names_to = "metric", values_to = "value") 
df_long$analysis <- factor(df_long$analysis, 
                           levels = c("joint", "sex-meta", "subpop-meta", "male", "female", 
                                      "S1", "S2", "S3"))
df_long$source <- factor(df_long$source, levels = unique(df_long$source))

main = df_long %>% filter(analysis == "joint" | analysis ==  "sex-meta" | analysis == 'subpop-meta' )

facet_title_color <- "#D3D3D380"
main_grouped <- main %>%
  mutate(row_group = case_when(
    metric %in% c("auc_vals", "auc_vals_gc") ~ "AUC",
    metric %in% c("infl_pvals", "infl_pvals_gc") ~ "Inflation Factor",
    metric %in% c("srmsd_vals", "srmsd_vals_gc") ~ "SRMSDp",
    TRUE ~ metric
  )) %>%
  mutate(metric_short = case_when(
    metric %in% c("auc_vals", "infl_pvals", "srmsd_vals") ~ "Original",
    metric %in% c("auc_vals_gc", "infl_pvals_gc", "srmsd_vals_gc") ~ "GC-corrected",
    TRUE ~ metric
  ),
  metric_short = factor(metric_short, levels = c("Original", "GC-corrected"))
  ) %>% 
  filter(
    (row_group != "Inflation Factor" & row_group != "SRMSDp" ) | 
      (row_group == "Inflation Factor" & value > 0.95 & value < 1.15) |
      (row_group == "SRMSDp" & value > -0.01 & value < 0.03)
  )

lines_df <- data.frame(
  yintercept = c(0.95, 1.05, -0.01, 0.01),
  row_group = c("Inflation Factor", "Inflation Factor", "SRMSDp", "SRMSDp")
)

png( '/hpc/group/ochoalab/tt207/meta_analysis_aim/plots/main_analyses_quant_gc.png', width=14, height=20, res=300, units = 'in')
ggplot(main_grouped , aes(x = source, y = value, fill = analysis)) +
  geom_hline(data = lines_df, aes(yintercept = yintercept), color = "gray", linewidth = 1.5, linetype = "dashed") +
  geom_boxplot(width = 0.6, alpha = 0.5, size = 1.2) +
  labs(x = "Simulation", y = "Value", fill = "Subset") + 
  theme_bw() + 
  facet_grid(rows = vars(row_group), cols = vars(metric_short), scales = "free_y") +
  scale_fill_nejm() + 
  theme(
    strip.background = element_rect(fill = facet_title_color, size = 1.5),
    panel.spacing = unit(1, "lines"), 
    strip.text = element_text(size = 36),
    axis.title = element_text(size = 27),
    legend.text = element_text(size = 28),
    axis.text = element_text(size = 26),
    legend.position = "top",
    legend.title = element_blank(),
    legend.key.size = unit(3, "lines"),
    panel.border = element_rect(linewidth = 1.5),
    axis.line = element_line(linewidth = 1.5)
  ) +
  guides(color = guide_legend(override.aes = list(size = 25)))
invisible( dev.off() )