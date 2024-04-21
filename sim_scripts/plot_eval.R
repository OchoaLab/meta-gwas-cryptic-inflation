library(tidyverse)
library(ggplot2)
library(gdata)
library(RColorBrewer)
library("ggsci")
setwd('/hpc/group/ochoalab/tt207/meta_analysis_aim/eval_tables')

sim1 = read.table("sim1_h08_1_20_new.txt", header = TRUE)
sim2 = read.table("sim2_h08_1_20_new.txt", header = TRUE)
sim3 = read.table("sim3_h08_1_20_new.txt", header = TRUE)
sim4_sex = read.table("sim4_h08_1_20.txt", header = TRUE)
sim4_subpop = read.table("sim4_h08_1_20_subpop.txt", header = TRUE)
sim4 = rbind(sim4_sex, sim4_subpop)
df = gdata::combine(sim1, sim2, sim3, sim4)

df_long = pivot_longer(df, cols = c(infl_pvals, srmsd_vals, auc_vals),
                                    names_to = "metric", values_to = "value") 
df_long$analysis <- factor(df_long$analysis, 
                           levels = c("joint", "sex-meta", "subpop-meta", "male", "female", "S1", "S2", "S3"))
df_long$source <- factor(df_long$source, levels = unique(df_long$source))

png( '/datacommons/ochoalab/tiffany_data/meta_analysis_aim/plots/all_infl.png', width=11, height=5, res=300, units = 'in')
ggplot(df_long %>% filter(metric == "infl_pvals"), aes(x = analysis, y = value, fill = source)) +
  geom_boxplot(width = 0.6, alpha = 0.4) +
  labs(x = "Analysis", y = "Inflation Factor",
       fill = "source") + theme_linedraw() +scale_fill_nejm() #scale_fill_brewer(palette = "Paired")

invisible( dev.off() )

png( '/datacommons/ochoalab/tiffany_data/meta_analysis_aim/plots/all_srmsd.png', width=11, height=5, res=300, units = 'in')
ggplot(df_long %>% filter(metric == "srmsd_vals"), aes(x = analysis, y = value, fill = source)) +
  geom_boxplot( alpha = 0.4) +
  labs(
       x = "Analysis", y = "srmsd",
       fill = "rep") + theme_bw()
invisible( dev.off() )

png( '/hpc/group/ochoalab/tt207/meta_analysis_aim/plots/all_auc.png', width=11, height=5, res=300, units = 'in')
ggplot(df_long %>% filter(metric == "auc_vals"), aes(x = analysis, y = value, fill = source)) +
  geom_boxplot(alpha = 0.4) +
  labs(
       x = "Analysis", y = "AUC",
       fill = "rep") + theme_bw()
invisible( dev.off() )


###########
# combine eval

main = df_long %>% filter(analysis == "joint" | analysis ==  "sex-meta" | analysis == 'subpop-meta')
sub = df_long %>% filter(analysis == "male" |  analysis == "female" | analysis == 'S1' | analysis == "S2" | analysis == "S3")

png( '/hpc/group/ochoalab/tt207/meta_analysis_aim/plots/main_analyses_auc_srmsd_new.png', width=11, height=5, res=300, units = 'in')
ggplot(main %>% filter(metric == "auc_vals" | metric == "srmsd_vals"), aes(x = source, y = value, fill = analysis)) +
  geom_boxplot(width = 0.6, alpha = 0.4) +
  labs(x = "Simulation", y = "Value",
       fill = "Subset") + theme_bw() +scale_fill_nejm() + facet_wrap(~metric, scales = "free_y")

invisible( dev.off() )

png( '/hpc/group/ochoalab/tt207/meta_analysis_aim/plots/sub_analyses_auc_srmsd_new.png', width=11, height=5, res=300, units = 'in')
ggplot(sub %>% filter(metric == "auc_vals" | metric == "srmsd_vals"), aes(x = source, y = value, fill = analysis)) +
  geom_boxplot(width = 0.6, alpha = 0.4) +
  labs(x = "Simulation", y = "Value",
       fill = "Subset") + theme_bw() +scale_fill_nejm() + facet_wrap(~metric, scales = "free_y")

invisible( dev.off() )

## new
main = df_long %>% filter(analysis == "joint" | analysis ==  "sex-meta") %>% 
  mutate(metric = ifelse(metric == "auc_vals", "AUC", ifelse(metric == "srmsd_vals", "SRMSD", metric)))
sub = df_long %>% filter(analysis == "male" |  analysis == "female") %>% 
  mutate(metric = ifelse(metric == "auc_vals", "AUC", ifelse(metric == "srmsd_vals", "SRMSD", metric)))

png( '/hpc/group/ochoalab/tt207/meta_analysis_aim/plots/main_sex_meta.png', width=11, height=5, res=300, units = 'in')
facet_title_color <- "#D3D3D380"
ggplot(main %>% filter(metric == "AUC" | metric == "SRMSD"), aes(x = source, y = value, fill = analysis)) +
  geom_boxplot(width = 0.6, alpha = 0.4) +
  labs(x = "Simulation", y = "Value",
       fill = "Subset") + theme_bw() + theme(strip.background = element_rect(fill = facet_title_color),
                                             strip.text = element_text(size = 16),
                                             axis.title = element_text(size = 12),
                                             legend.title = element_text(size = 14),  # Adjust the legend title font size
                                             legend.text = element_text(size = 12)) +
  scale_fill_nejm() + facet_wrap(~metric, scales = "free_y") +
  guides(color = guide_legend(override.aes = list(size = 7)))
invisible( dev.off() )

png( '/hpc/group/ochoalab/tt207/meta_analysis_aim/plots/sub_sex_meta.png', width=11, height=5, res=300, units = 'in')
ggplot(sub %>% filter(metric == "AUC" | metric == "SRMSD"), aes(x = source, y = value, fill = analysis)) +
  geom_boxplot(width = 0.6, alpha = 0.4) +
  labs(x = "Simulation", y = "Value",
       fill = "Subset") + theme_bw() + theme(strip.background = element_rect(fill = facet_title_color))+scale_fill_nejm() + facet_wrap(~metric, scales = "free_y")

invisible( dev.off() )

sex_meta = df_long %>% filter(analysis == "joint" | analysis ==  "sex-meta" | analysis == "male" |  analysis == "female") %>% 
  mutate(metric = ifelse(metric == "auc_vals", "AUC", ifelse(metric == "srmsd_vals", "SRMSD", metric)))
png( '/hpc/group/ochoalab/tt207/meta_analysis_aim/plots/all_sex_meta.png', width=11, height=5, res=300, units = 'in')
facet_title_color <- "#D3D3D380"
  ggplot(sex_meta %>% filter(metric == "AUC" | metric == "SRMSD"), aes(x = source, y = value, fill = analysis)) +
    geom_boxplot(width = 0.6, alpha = 0.4) +
    labs(x = "Simulation", y = "Value",
         fill = "Subset") + theme_bw() + theme(strip.background = element_rect(fill = facet_title_color),
                                               strip.text = element_text(size = 16),
                                               axis.title = element_text(size = 12),
                                               legend.title = element_text(size = 14),  # Adjust the legend title font size
                                               legend.text = element_text(size = 12)) +
    scale_fill_nejm() + facet_wrap(~metric, scales = "free_y") +
    guides(color = guide_legend(override.aes = list(size = 7)))
  invisible( dev.off() )


subpop_meta = df_long %>% filter(analysis == "joint" | analysis ==  "subpop-meta" | analysis == "S1" |  analysis == "S2" |  analysis == "S3") %>% 
  mutate(metric = ifelse(metric == "auc_vals", "AUC", ifelse(metric == "srmsd_vals", "SRMSD", metric)))
png( '/hpc/group/ochoalab/tt207/meta_analysis_aim/plots/all_subpop_meta.png', width=11, height=5, res=300, units = 'in')
facet_title_color <- "#D3D3D380"
  ggplot(subpop_meta %>% filter(metric == "AUC" | metric == "SRMSD"), aes(x = source, y = value, fill = analysis)) +
    geom_boxplot(width = 0.6, alpha = 0.4) +
    labs(x = "Simulation", y = "Value",
         fill = "Subset") + theme_bw() + theme(strip.background = element_rect(fill = facet_title_color),
                                               strip.text = element_text(size = 16),
                                               axis.title = element_text(size = 12),
                                               legend.title = element_text(size = 14),  # Adjust the legend title font size
                                               legend.text = element_text(size = 12)) +
    scale_fill_nejm() + facet_wrap(~metric, scales = "free_y") +
    guides(color = guide_legend(override.aes = list(size = 7)))
  invisible( dev.off() )

######
# single analysis testing

sim4 = read.table("sim4_h08_1-20.txt", header = TRUE)

df_long = pivot_longer(sim4, cols = c(infl_pvals, srmsd_vals, auc_vals),
                       names_to = "metric", values_to = "value") 
df_long$analysis <- factor(df_long$analysis, 
                           levels = c("joint", "sex-meta",  "male", "female"))

main = df_long %>% filter(analysis == "joint" | analysis ==  "sex-meta" )
sub = df_long %>% filter(analysis == "male" |  analysis == "female")

png( '/hpc/group/ochoalab/tt207/meta_analysis_aim/plots/main_analyses_sim4.png', width=11, height=5, res=300, units = 'in')
ggplot(main, aes(x = analysis, y = value)) +
  geom_boxplot(width = 0.6, alpha = 0.4) +
  labs(x = "Analysis", y = "Value") + theme_bw() +scale_fill_nejm() + facet_wrap(~metric, scales = "free_y")

invisible( dev.off() )

png( '/hpc/group/ochoalab/tt207/meta_analysis_aim/plots/sub_analyses_sim4.png', width=11, height=5, res=300, units = 'in')
ggplot(sub, aes(x = analysis, y = value)) +
  geom_boxplot(width = 0.6, alpha = 0.4) +
  labs(x = "Analysis", y = "Value") + theme_bw() +scale_fill_nejm() + facet_wrap(~metric, scales = "free_y")

invisible( dev.off() )
