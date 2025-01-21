library(tidyverse)
library(qqman)
library(ggplot2)
library(gdata)

setwd('/datacommons/ochoalab/tiffany_data/meta_analysis_aim/METAL/real_data/')

df_all = read.table("/datacommons/ochoalab/ssns_gwas/saige/ns_ctrl/saige_output.txt", header = TRUE) 
df_all_clean = df_all %>% select(CHR, POS, P.value = p.value) %>% filter(CHR != 6)
df_male = read.table("/datacommons/ochoalab/ssns_gwas/saige/ns_male/saige_output.txt", header = TRUE) 
df_male_clean = df_male %>% select(CHR, POS, P.value = p.value)  %>% filter(CHR != 6)
df_female = read.table("/datacommons/ochoalab/ssns_gwas/saige/ns_female/saige_output.txt", header = TRUE) 
df_female_clean = df_female %>% select(CHR, POS, P.value = p.value)  %>% filter(CHR != 6)

df_chr_pos = df_all %>% select(CHR, POS, MarkerID)
# load meta
meta <- read.table("/datacommons/ochoalab/tiffany_data/meta_analysis_aim/METAL/real_data/output_metal_sex_ns1.txt", sep = "\t", stringsAsFactors=FALSE, quote = "", header = TRUE) %>% 
  arrange(MarkerName) 
df_meta = merge(meta, df_chr_pos, by.x = "MarkerName", by.y = "MarkerID") %>% select(CHR, POS, P.value)  %>% filter(CHR != 6)
df = gdata::combine(df_all_clean, df_male_clean, df_female_clean, df_meta)

library(simtrait)
# for each of the p-value sets (repeat for pvals1, ..., pvals4)
# returns a list containing the data to plot
obj1_real <- pval_srmsd( df_all_clean$P.value, causal_indexes = NULL, detailed = TRUE )
obj1_real$pvals_unif <- -log10( obj1_real$pvals_unif )
obj1_real$pvals_null <- -log10( obj1_real$pvals_null )

obj2_real <- pval_srmsd( df_male_clean$P.value, causal_indexes = NULL, detailed = TRUE )
obj2_real$pvals_unif <- -log10( obj2_real$pvals_unif )
obj2_real$pvals_null <- -log10( obj2_real$pvals_null )

obj3_real <- pval_srmsd( df_female_clean$P.value, causal_indexes = NULL, detailed = TRUE )
obj3_real$pvals_unif <- -log10( obj3_real$pvals_unif )
obj3_real$pvals_null <- -log10( obj3_real$pvals_null )

obj4_real <- pval_srmsd( df_meta$P.value, causal_indexes = NULL, detailed = TRUE )
obj4_real$pvals_unif <- -log10( obj4_real$pvals_unif )
obj4_real$pvals_null <- -log10( obj4_real$pvals_null )
# now get the combined range for plot
range_expected <- range( obj1_real$pvals_unif, obj2_real$pvals_unif, obj3_real$pvals_unif, obj4_real$pvals_unif)
range_observed <- range( obj1_real$pvals_null, obj2_real$pvals_null, obj3_real$pvals_null, obj4_real$pvals_null)

# initialize plot
png( '/datacommons/ochoalab/tiffany_data/meta_analysis_aim/plots/real_data/sex_qq.png', width=6, height=5, res=300, units = 'in')
# add labels and additional details as needed
plot( NA, xlim = range_expected, ylim = range_observed, main = "NS vs Control", xlab = "Expected -log(p-val)", ylab = "Observed -log(p-val)")
# add diagonal
abline( 0, 1, lty = 2, col = 'gray' )
# now add each set of points (repeat for obj1, ... obj4 ), use different colors to differentiate
points( obj1_real$pvals_unif, obj1_real$pvals_null, pch = '.', col = "blue" , cex = 2)
points( obj2_real$pvals_unif, obj2_real$pvals_null, pch = '.', col = "green" , cex = 2)
points( obj3_real$pvals_unif, obj3_real$pvals_null, pch = '.', col = "magenta" , cex = 2)
points( obj4_real$pvals_unif, obj4_real$pvals_null, pch = '.', col = "red" , cex = 2)
# points( obj5_real$pvals_unif, obj5_real$pvals_null, pch = '.', col = "red" )
# add legend
legend( 'topleft', c('Joint', 'Male', 'Female', 'Meta analysis'), col = c("blue", "green", 'magenta', "red"), pch = 16 )
invisible( dev.off() )

pval_discovery = pval_infl(df_all_clean$P.value)
pval_male = pval_infl(df_male_clean$P.value)
pval_female = pval_infl(df_female_clean$P.value)
pval_meta = pval_infl(df_meta$P.value)
