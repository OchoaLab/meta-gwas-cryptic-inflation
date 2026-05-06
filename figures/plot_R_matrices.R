library(tidyverse)
library(ggplot2)

r_dir <- "/hpc/dctrl/tt207/meta_analysis_aim/eval_tables/R_matrices"
plot_dir <- "/hpc/group/ochoalab/tt207/meta_analysis_aim/plots"

sims <- c("sim1_h08", "sim2_h08", "sim3_h08", "sim4_h08")
sim_labels <- c("sim1", "sim2", "sim3", "sim4")

# Heatmap of average R matrix per simulation

make_heatmap_data <- function(sims, sim_labels, strat, trait, method_suffix = "_median") {
  all_rows <- data.frame()
  for (i in seq_along(sims)) {
    R_sum <- NULL
    n_reps <- 0
    for (rep_num in 1:20) {
      r_file <- paste0(r_dir, "/", sims[i], "_rep", rep_num, "_", strat, "_", trait, method_suffix, ".txt")
      if (!file.exists(r_file)) next
      R <- as.matrix(read.table(r_file, header = TRUE))
      if (is.null(R_sum)) {
        R_sum <- R
      } else {
        R_sum <- R_sum + R
      }
      n_reps <- n_reps + 1
    }
    if (n_reps == 0) next
    R_avg <- R_sum / n_reps
    n <- nrow(R_avg)
    # Convert to long format using numeric indices
    for (row in seq_len(n)) {
      for (col in seq_len(n)) {
        all_rows <- rbind(all_rows, data.frame(
          sim = sim_labels[i],
          row_var = as.character(row),
          col_var = as.character(col),
          value = R_avg[row, col],
          stringsAsFactors = FALSE
        ))
      }
    }
  }
  return(all_rows)
}

# Build heatmap data
heat_sex_binary <- make_heatmap_data(sims, sim_labels, "sex", "binary") %>% 
  mutate(strat = "sex-meta-corr", trait = "Binary")
heat_sex_quant <- make_heatmap_data(sims, sim_labels, "sex", "quant") %>% 
  mutate(strat = "sex-meta-corr", trait = "Quantitative")
heat_subpop_binary <- make_heatmap_data(sims, sim_labels, "subpop", "binary") %>% 
  mutate(strat = "subpop-meta-corr", trait = "Binary")
heat_subpop_quant  <- make_heatmap_data(sims, sim_labels, "subpop", "quant") %>% 
  mutate(strat = "subpop-meta-corr", trait = "Quantitative")

heat_all <- rbind(heat_sex_binary, heat_sex_quant, heat_subpop_binary, heat_subpop_quant)
heat_all$sim <- factor(heat_all$sim, levels = sim_labels)

# Row label
heat_all <- heat_all %>%
  mutate(row_label = paste0(trait, "\n", strat))
heat_all$row_label <- factor(heat_all$row_label,
                             levels = c("Binary\nsex-meta-corr", "Quantitative\nsex-meta-corr",
                                        "Binary\nsubpop-meta-corr", "Quantitative\nsubpop-meta-corr"))

# Reverse row_var so diagonal goes top-left to bottom-right
heat_all$col_var <- factor(heat_all$col_var, levels = c("1", "2", "3"))
heat_all$row_var <- factor(heat_all$row_var, levels = c("3", "2", "1"))

# --- Heatmap: R - I (deviation from identity) ---
# Subtract identity so diagonal deviation from 1 and off-diagonal deviation from 0
# are on the same scale, centered at 0 (white)
heat_dev <- heat_all %>%
  mutate(deviation = ifelse(row_var == col_var, value - 1, value))

png(paste0(plot_dir, '/R_matrix_heatmap_deviation.png'),
    width = 24, height = 20, res = 300, units = 'in')
ggplot(heat_dev, aes(x = col_var, y = row_var, fill = deviation)) +
  geom_tile(color = "white", linewidth = 1) +
  geom_text(aes(label = sprintf("%.3f", value)), size = 7) +
  scale_fill_gradient2(low = "#357EBD", mid = "white", high = "#D43F3A",
                       midpoint = 0, name = "Deviation from \nIdentity matrix") +
  labs(x = NULL, y = NULL) +
  theme_minimal() +
  facet_grid(rows = vars(row_label), cols = vars(sim),
             scales = "free_y", space = "free_y", switch = "y") +
  theme(
    strip.text.y.left = element_text(size = 26, angle = 90, margin = margin(r = 15)),
    strip.text.x = element_text(size = 30, hjust = 0.5),
    strip.placement = "outside",
    axis.text = element_text(size = 18),
    legend.text = element_text(size = 20),
    legend.title = element_text(size = 25),
    legend.key.size = unit(3, "lines"),
    legend.position = "bottom",
    legend.box.margin = margin(t = 20, r = 0, b = 0, l = 0),
    panel.grid = element_blank()
  )
invisible(dev.off())