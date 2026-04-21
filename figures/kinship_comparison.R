library(tidyverse)
library(genio)
library(ggplot2)
library(popkin)

# Previous simulation (sim4_h08, N=3000)
grm_old <- read_grm("./sim4_h08/rep1/30G_kinship_G_3000n_100causal_500000m")
K_old <- grm_old$kinship
K_old <- rescale_popkin(K_old)
# New subset (sim4_3000, N=3000 drawn from sim4_10000)
grm_new <- read_grm("./sim4_3000/rep1/30G_kinship_G_3000n_100causal_500000m")
K_new <- grm_new$kinship
K_new <- rescale_popkin(K_new)

diag_vals <- diag(K_new)  
max(diag_vals)
# Per-individual kinship summary (sim4_3000 subset)
K <- K_new
diag(K) <- NA
per_ind <- data.frame(
  iid    = grm_new$fam$id,
  mean_k = rowMeans(K, na.rm = TRUE),
  n_zero = rowSums(K == 0, na.rm = TRUE),
  n_pos  = rowSums(K > 0,  na.rm = TRUE)
)
head(per_ind[order(per_ind$n_pos), ], 10)
head(per_ind[order(-per_ind$n_zero), ], 20)
per_ind[per_ind$n_zero > 0, ] %>% arrange(desc(n_zero)) %>% head(20)

# Extract lower triangle (keep zeros and negatives for survival denominator)
vals_old <- K_old[lower.tri(K_old)]
vals_new <- K_new[lower.tri(K_new)]

# Keep all values (including zeros and negatives) so the survival
# function is computed against the full denominator
all_df <- rbind(
  data.frame(kinship = vals_old, source = 'sim4 (N=3000)'),
  data.frame(kinship = vals_new, source = 'sim4 from subset (N=3000)')
)

# Compute survival function (1 - ECDF) per source using ALL values
surv_df <- all_df %>%
  group_by(source) %>%
  arrange(kinship) %>%
  mutate(surv = 1 - (row_number() / n())) %>%
  ungroup() %>%
  filter(kinship > 0)   # plot only positive kinship (log scale)

fig <- ggplot(surv_df, aes(x = kinship, y = surv, color = source)) +
  geom_step(linewidth = 0.6) +
  scale_x_log10() +
  labs(x = 'Kinship estimate',
       y = 'Cumulative distribution',
       color = 'Source') +
  theme_classic() +
  theme(legend.position = 'top')

ggsave(
  filename = 'kinship_cdf_comparison.pdf',
  plot     = fig,
  width    = 7,
  height   = 5,
  units    = 'in',
  device   = cairo_pdf
)

# ------------------------------------------------------------------
# Side-by-side kinship matrix heatmaps via popkin
# ------------------------------------------------------------------
popkin_list <- list(
  'sim4 (N=3000)'             = K_old,
  'sim4 from subset (N=3000)' = K_new
)

png('kinship_matrix_comparison.png',
    width = 11, height = 5.5, res = 300, units = 'in')
par(mar = c(1, 4, 2.5, 1) + 2)
plot_popkin(
  popkin_list,
  panel_letters_cex = 2,
  # zero inner margin (plus padding) because we have no labels
  mar       = c(2, 2.5, 3, 0.1),
  leg_title = 'Kinship',
  leg_mar   = c(2.5, 2, 2.5, 4),
  leg_width = 0.3
)
invisible(dev.off())
