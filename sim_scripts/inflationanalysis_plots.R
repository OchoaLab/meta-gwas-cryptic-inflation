library(tidyverse)
library(qqman)
library(simtrait)
female_out <- read.table("/datacommons/ochoalab/ssns_gwas/nephrotic.syndrome.gwas_proprocessing_202205/allele_freq/newfiles_alpha/imputation_10_new/results/GMMAT/meta_analysis/sex/glmm.score.bed.female_mac20.txt", sep = "\t", stringsAsFactors=FALSE, quote = "", header = TRUE)
male_out <- read.table("/datacommons/ochoalab/ssns_gwas/nephrotic.syndrome.gwas_proprocessing_202205/allele_freq/newfiles_alpha/imputation_10_new/results/GMMAT/meta_analysis/sex/glmm.score.bed.male_mac20.txt", sep = "\t", stringsAsFactors=FALSE, quote = "", header = TRUE)
gmmat_out <- read.table("/datacommons/ochoalab/ssns_gwas/nephrotic.syndrome.gwas_proprocessing_202205/allele_freq/newfiles_alpha/imputation_10_new/results/GMMAT/full_data/glmm.score.bed.all_20.txt", sep = "\t", stringsAsFactors=FALSE, quote = "", header = TRUE)
meta_out <- read.table("/datacommons/ochoalab/ssns_gwas/nephrotic.syndrome.gwas_proprocessing_202205/allele_freq/newfiles_alpha/imputation_10_new/results/GMMAT/meta_analysis/sex/gmmat_sex_meta.txt", sep = "\t", stringsAsFactors=FALSE, quote = "", header = TRUE)

# female_sub = female_out %>% arrange(p) %>% head(8030972)
# male_sub = male_out %>% arrange(p) %>% head(8030972)
# gmmat_sub = gmmat_out %>% arrange(p) %>% head(8030972)
# meta_sub = meta_out %>% arrange(P.value) %>% head(8030972) %>%
#   separate(SNP, c('Chr', 'bp', "A1", "A2")) %>%
#   mutate(Chr = as.numeric(gsub("chr", "", Chr)), bp = as.numeric(bp))

results_f = female_out %>% select(SNP, CHR, BP = POS, P = PVAL) %>% drop_na(P) %>%
  arrange(CHR, BP)
results_m = male_out %>% select(SNP, CHR, BP = POS, P = PVAL) %>% drop_na(P) %>%
  arrange(CHR, BP)
results_gmmat = gmmat_out %>% select(SNP, CHR, BP = POS, P = PVAL) %>% drop_na(P) %>%
  arrange(CHR, BP)
results_meta = meta_out %>%
  separate(SNP, c('Chr', 'bp', "A1", "A2")) %>%
  mutate(Chr = as.numeric(gsub("chr", "", Chr)), bp = as.numeric(bp)) %>%
  select(CHR = Chr, BP = bp, P = PVAL) %>% drop_na(P) %>% mutate(SNP = 1)

results_f_rm6 = results_f %>% filter(CHR != 6)
results_m_rm6 = results_m %>% filter(CHR != 6)
results_gmmat_rm6 = results_gmmat %>% filter(CHR != 6)
results_meta_rm6 = results_meta %>% filter(CHR != 6)

pval_infl(results_f$P)
pval_infl(results_m$P)
pval_infl(results_gmmat$P)
pval_infl(results_meta$P)

pval_infl(results_f_rm6$P)
pval_infl(results_m_rm6$P)
pval_infl(results_gmmat_rm6$P)
pval_infl(results_meta_rm6$P)
# options(bitmapType='cairo')
png( '/datacommons/ochoalab/ssns_gwas/nephrotic.syndrome.gwas_proprocessing_202205/allele_freq/newfiles_alpha/imputation_10_new/results/GMMAT/meta_analysis/sex/NS_man_gmmat.png', width=12, height=9, res=300, units = 'in')
par( mfrow = c(4,1) )
manhattan(results_f %>% arrange(P) %>% head(8030972), annotateTop = FALSE, main = "Female", ylim=c(0,15))
manhattan(results_m %>% arrange(P) %>% head(8030972), annotateTop = FALSE, main = "Male", ylim=c(0,15))
manhattan(results_gmmat %>% arrange(P) %>% head(8030972), annotateTop = FALSE, main = "Full dataset: joint analysis", ylim=c(0,15))
manhattan(results_meta %>% arrange(P) %>% head(8030972), annotateTop = FALSE, main = "meta-analysis", ylim=c(0,15))
invisible( dev.off() )

png( '/datacommons/ochoalab/ssns_gwas/nephrotic.syndrome.gwas_proprocessing_202205/allele_freq/newfiles_alpha/imputation_10_new/results/GMMAT/meta_analysis/sex/NS_man_gmmat_rm6.png', width=12, height=9, res=300, units = 'in')
par( mfrow = c(4,1) )
manhattan(results_f_rm6 %>% arrange(P) %>% head(8030972), annotateTop = FALSE, main = "Female (rm chr6)", ylim=c(0,15))
manhattan(results_m_rm6 %>% arrange(P) %>% head(8030972), annotateTop = FALSE, main = "Male (rm chr6)", ylim=c(0,15))
manhattan(results_gmmat_rm6 %>% arrange(P) %>% head(8030972), annotateTop = FALSE, main = "Full dataset: joint analysis (rm chr6)", ylim=c(0,15))
manhattan(results_meta_rm6 %>% arrange(P) %>% head(8030972), annotateTop = FALSE, main = "meta-analysis (rm chr6)", ylim=c(0,15))
invisible( dev.off() )

# 
# options(bitmapType='cairo')
png( '/datacommons/ochoalab/ssns_gwas/nephrotic.syndrome.gwas_proprocessing_202205/allele_freq/newfiles_alpha/imputation_10_new/results/GMMAT/meta_analysis/sex/NS_qq_gmmat.png', width=6, height=8, res=300, units = 'in')
par( mfrow = c(4,2) )
hist(results_f %>% arrange(P) %>% head(8030972) %>% select(P), main= "Histogram of females p-values", xlab = "p", col = "gray")
qq(results_f$P)
hist(results_m$P, main= "Histogram of males p-values", xlab = "p", col = "gray")
qq(results_m$P)
hist(results_gmmat$P, main= "Histogram of joint analysis p-values", xlab = "p", col = "gray")
qq(results_gmmat$P)
hist(results_meta$P, main= "Histogram of meta analysis p-values", xlab = "p", col = "gray")
qq(results_meta$P)
invisible( dev.off() )


png( '/datacommons/ochoalab/ssns_gwas/nephrotic.syndrome.gwas_proprocessing_202205/allele_freq/newfiles_alpha/imputation_10_new/results/GMMAT/meta_analysis/sex/NS_qq_gmmat_rm6.png', width=6, height=8, res=300, units = 'in')
par( mfrow = c(4,2) )
hist(results_f_rm6$P, main= "Histogram of females p-values (rm chr6)", xlab = "p", col = "gray")
qq(results_f_rm6$P)
hist(results_m_rm6$P, main= "Histogram of males p-values (rm chr6)", xlab = "p", col = "gray")
qq(results_m_rm6$P)
hist(results_gmmat_rm6$P, main= "Histogram of joint analysis p-values (rm chr6)", xlab = "p", col = "gray")
qq(results_gmmat_rm6$P)
hist(results_meta_rm6$P, main= "Histogram of meta analysis p-values (rm chr6)", xlab = "p", col = "gray")
qq(results_meta_rm6$P)
invisible( dev.off() )


## inflation analysis
library(simtrait)
# for each of the p-value sets (repeat for pvals1, ..., pvals4)
# returns a list containing the data to plot
obj1_real <- pval_srmsd( results_f$P, causal_indexes = NULL, detailed = TRUE )
obj1_real$pvals_unif <- -log10( obj1_real$pvals_unif )
obj1_real$pvals_null <- -log10( obj1_real$pvals_null )

obj2_real <- pval_srmsd( results_m$P, causal_indexes = NULL, detailed = TRUE )
obj2_real$pvals_unif <- -log10( obj2_real$pvals_unif )
obj2_real$pvals_null <- -log10( obj2_real$pvals_null )

obj3_real <- pval_srmsd( results_gmmat$P, causal_indexes = NULL, detailed = TRUE )
obj3_real$pvals_unif <- -log10( obj3_real$pvals_unif )
obj3_real$pvals_null <- -log10( obj3_real$pvals_null )

obj4_real <- pval_srmsd( results_meta$P, causal_indexes = NULL, detailed = TRUE )
obj4_real$pvals_unif <- -log10( obj4_real$pvals_unif )
obj4_real$pvals_null <- -log10( obj4_real$pvals_null )

# now get the combined range for plot
range_expected <- range( obj1_real$pvals_unif, obj2_real$pvals_unif, obj3_real$pvals_unif, obj4_real$pvals_unif)
range_observed <- range( obj1_real$pvals_null, obj2_real$pvals_null, obj3_real$pvals_null, obj4_real$pvals_null)
# initialize plot
png( '/datacommons/ochoalab/ssns_gwas/nephrotic.syndrome.gwas_proprocessing_202205/allele_freq/newfiles_alpha/imputation_10_new/results/GMMAT/meta_analysis/sex/inflation_analysis.png', width=12, height=9, res=300, units = 'in')

# add labels and additional details as needed
plot( NA, xlim = range_expected, ylim = range_observed, main = "Real data: NS + TGP imputed - GMMAT analysis", xlab = "Expected -log(p-val)", ylab = "Observed -log(p-val)")
# add diagonal
abline( 0, 1, lty = 2, col = 'gray' )
# now add each set of points (repeat for obj1, ... obj4 ), use different colors to differentiate
points( obj1_real$pvals_unif, obj1_real$pvals_null, pch = '.', col = "blue" )
points( obj2_real$pvals_unif, obj2_real$pvals_null, pch = '.', col = "purple" )
points( obj3_real$pvals_unif, obj3_real$pvals_null, pch = '.', col = "green" )
points( obj4_real$pvals_unif, obj4_real$pvals_null, pch = '.', col = "red" )
# add legend
legend( 'topleft', c('female', 'male', 'full dataset', 'GMMAT:sex-meta'), col = c("blue", "purple", "green", "red"), pch = 16 )
invisible( dev.off() )

obj1 <- pval_srmsd( results_f_rm6$P, causal_indexes = NULL, detailed = TRUE )

obj1$pvals_unif <- -log10( obj1$pvals_unif )
obj1$pvals_null <- -log10( obj1$pvals_null )

obj2 <- pval_srmsd( results_m_rm6$P, causal_indexes = NULL, detailed = TRUE )
obj2$pvals_unif <- -log10( obj2$pvals_unif )
obj2$pvals_null <- -log10( obj2$pvals_null )

obj3 <- pval_srmsd( results_gmmat_rm6$P, causal_indexes = NULL, detailed = TRUE )
obj3$pvals_unif <- -log10( obj3$pvals_unif )
obj3$pvals_null <- -log10( obj3$pvals_null )

obj4 <- pval_srmsd( results_meta_rm6$P, causal_indexes = NULL, detailed = TRUE )
obj4$pvals_unif <- -log10( obj4$pvals_unif )
obj4$pvals_null <- -log10( obj4$pvals_null )

# now get the combined range for plot
range_expected <- range( obj1$pvals_unif, obj2$pvals_unif, obj3$pvals_unif, obj4$pvals_unif)
range_observed <- range( obj1$pvals_null, obj2$pvals_null, obj3$pvals_null, obj4$pvals_null)
# initialize plot
png( '/datacommons/ochoalab/ssns_gwas/nephrotic.syndrome.gwas_proprocessing_202205/allele_freq/newfiles_alpha/imputation_10_new/results/GMMAT/meta_analysis/sex/inflation_analysis_rm6.png', width=12, height=9, res=300, units = 'in')
# add labels and additional details as needed
plot( NA, xlim = range_expected, ylim = range_observed, main = "Real data: NS + TGP imputed (excluding chr6) - GMMAT analysis", xlab = "Expected -log(p-val)", ylab = "Observed -log(p-val)")
# add diagonal
abline( 0, 1, lty = 2, col = 'gray' )
# now add each set of points (repeat for obj1, ... obj4 ), use different colors to differentiate
points( obj1$pvals_unif, obj1$pvals_null, pch = '.', col = "blue" )
points( obj2$pvals_unif, obj2$pvals_null, pch = '.', col = "purple" )
points( obj3$pvals_unif, obj3$pvals_null, pch = '.', col = "green" )
points( obj4$pvals_unif, obj4$pvals_null, pch = '.', col = "red" )
# add legend
legend( 'topleft', c('female', 'male', 'full dataset', 'METAL:sex-meta'), col = c("blue", "purple", "green", "red"), pch = 16 )
invisible( dev.off() )