library(tidyverse)
library(dplyr)
library(tidyr)
library(ggplot2)

setwd('/hpc/group/ochoalab/tt207/meta_analysis_aim')

df <- read.table('./eval_tables/sim4_N10000_8000_6000_4000_2000_quant_metacorr.txt', header = TRUE) %>%
  filter(analysis %in% c('joint', 'sex-meta', 'sex-meta-corr')) %>%
  mutate(analysis = factor(analysis, levels = c('joint', 'sex-meta', 'sex-meta-corr')),
         N        = factor(N,        levels = c(2000, 4000, 6000, 8000, 10000))) 

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

# Reference lines drawn only on matching facets
lines_df <- data.frame(
  yintercept = c(0.95, 1.05, -0.01, 0.01),
  metric     = factor(c('Inflation Factor', 'Inflation Factor',
                        'SRMSDp',           'SRMSDp'),
                      levels = c('AUC', 'Inflation Factor', 'SRMSDp'))
)

analysis_colors <- c('joint' = '#F8766D', 'sex-meta' = '#619CFF', 'sex-meta-corr' = '#00BA38')

# Summarize for mean line
df_summary <- df_long %>%
  group_by(analysis, N, metric) %>%
  summarise(
    mean_val = mean(value, na.rm = TRUE),
    .groups  = 'drop'
  )

# Point + line plot: individual points with mean connected by lines
fig <- ggplot(df_long, aes(x = N, y = value, color = analysis, group = analysis)) +
  geom_hline(data = lines_df, aes(yintercept = yintercept),
             color = 'gray', linewidth = 0.8, linetype = 'dashed') +
  geom_point(position = position_dodge(width = 0.4),
             size = 1.5, alpha = 0.4) +
  geom_line(data = df_summary, aes(y = mean_val),
            position = position_dodge(width = 0.4),
            linewidth = 0.8) +
  geom_point(data = df_summary, aes(y = mean_val),
             position = position_dodge(width = 0.4),
             size = 3, shape = 18) +
  facet_wrap(~ metric, scales = 'free_y', nrow = 1) +
  scale_color_manual(values = analysis_colors, name = 'Analysis') +
  labs(x = 'Sample Size', y = 'Values') +
  theme_bw() +
  theme(legend.position  = 'top',
        legend.text = element_text(size = 10),
        panel.spacing    = unit(0.4, 'cm'),
        panel.grid       = element_blank(),
        strip.background = element_rect(fill = 'white', color = 'black'),
        strip.text       = element_text(size = 12))

ggsave(
  filename = file.path(plots_dir, 'sim4_main_sex_meta_quant_metacorr.pdf'),
  plot     = fig,
  width    = 10,
  height   = 4.5,
  units    = 'in',
  device   = cairo_pdf
)
