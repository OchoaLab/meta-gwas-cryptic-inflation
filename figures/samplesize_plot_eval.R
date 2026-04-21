library(tidyverse)
library(dplyr)
library(tidyr)
library(ggplot2)
library(ggpubr)

setwd('/hpc/group/ochoalab/tt207/meta_analysis_aim')

df <- read.table('./eval_tables/sim4_N10000_8000_6000_4000_2000quant.txt', header = TRUE) %>%
  filter(analysis %in% c('joint', 'sex-meta')) %>%
  mutate(analysis = factor(analysis, levels = c('joint', 'sex-meta')),
         N        = factor(N,        levels = c(10000, 8000, 6000, 4000, 2000)))

df_long <- pivot_longer(df,
                        cols = c(infl_pvals, srmsd_vals, auc_vals),
                        names_to = 'metric', values_to = 'value') %>%
  mutate(metric = recode(metric,
                         auc_vals   = 'AUC',
                         infl_pvals = 'Inflation Factor',
                         srmsd_vals = 'SRMSDp'),
         metric = factor(metric, levels = c('AUC', 'Inflation Factor', 'SRMSDp')))

plots_dir <- '/hpc/group/ochoalab/tt207/meta_analysis_aim/plots'
dir.create(plots_dir, showWarnings = FALSE, recursive = TRUE)

lines_df <- data.frame(
  yintercept = c(0.95, 1.05, -0.01, 0.01),
  metric     = factor(c('Inflation Factor', 'Inflation Factor',
                        'SRMSDp',           'SRMSDp'),
                      levels = c('AUC', 'Inflation Factor', 'SRMSDp'))
)

n_colors <- c('10000' = '#253494',
              '8000'  = '#2c7fb8',
              '6000'  = '#41b6c4',
              '4000'  = '#7fcdbb',
              '2000'  = '#c7e9b4')

fig <- ggplot(df_long, aes(x = analysis, y = value, fill = N)) +
  geom_hline(data = lines_df, aes(yintercept = yintercept),
             color = 'gray', linewidth = 1, linetype = 'dashed') +
  geom_boxplot(width = 0.7, alpha = 0.9,
               outlier.size = 0.8, outlier.color = 'gray60') +
  facet_wrap(~ metric, scales = 'free_y', nrow = 1) +
  scale_fill_manual(values = n_colors, name = 'N') +
  labs(x = 'Analysis', y = 'Values') +
  theme_bw() +
  theme(legend.position  = 'top',
        panel.spacing    = unit(0.4, 'cm'),
        panel.grid       = element_blank(),
        strip.background = element_rect(fill = 'white', color = 'black'),
        strip.text       = element_text(size = 12))

ggsave(
  filename = file.path(plots_dir, 'sim4_main_sex_meta_quant.pdf'),
  plot     = fig,
  width    = 9,
  height   = 4.5,
  units    = 'in',
  device   = cairo_pdf
)
