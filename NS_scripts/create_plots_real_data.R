library(tidyverse)
library(karyoploteR)
setwd('/datacommons/ochoalab/tiffany_data/meta_analysis_aim/')

df_all = read.table("/datacommons/ochoalab/ssns_gwas/saige/ns_ctrl/saige_output.txt", header = TRUE) 
df_chr_pos = df_all %>% select(CHR, POS, MarkerID)
# df_S1_complete = merge(df_chr_pos, df_S1, by = c("CHR", "POS", "MarkerID"), all.x = TRUE)
# df_S2_complete = merge(df_chr_pos, df_S2, by = c("CHR", "POS", "MarkerID"), all.x = TRUE)
# df_S3_complete = merge(df_chr_pos, df_S3, by = c("CHR", "POS", "MarkerID"), all.x = TRUE)

# load meta
meta_sex <- read.table("/datacommons/ochoalab/tiffany_data/meta_analysis_aim/METAL/real_data/output_metal_sex_ns1.txt", sep = "\t", stringsAsFactors=FALSE, quote = "", header = TRUE) %>% 
  arrange(MarkerName) 
df_meta_sex = merge(meta_sex, df_chr_pos, by.x = "MarkerName", by.y = "MarkerID")

# GR
GR_input = df_all %>% mutate(chr = paste0("chr", CHR), start = POS, end = POS) %>% 
  select(chr, start, end, A1 = Allele1, A2 = Allele2, P = p.value) 
ns_gr = makeGRangesFromDataFrame(data.frame(GR_input), keep.extra.columns = TRUE)

GR_input = df_meta_sex %>% separate(MarkerName, c("CHROM", "POS", "A1", "A2"), ":") %>% 
  mutate(start = as.numeric(POS), end = as.numeric(POS)) %>% 
  select(-Allele1, -Allele2, -POS) %>% select(chr = CHROM, start, end, A1, A2, P = P.value) 
meta_gr = makeGRangesFromDataFrame(data.frame(GR_input), keep.extra.columns = TRUE)


png( '/datacommons/ochoalab/tiffany_data/meta_analysis_aim/real_data/ns_meta_manplots.png', width=18.5, height=10, res=800, units = 'in')
#par(mfrow=c(5,3), mar=c(2,2,2,2))
chr_plot = c("chr1", "chr2", "chr3", "chr4", "chr5", "chr6", "chr7", "chr8", "chr9", "chr10", "chr11", 
             "chr12", "chr13", "chr14", "chr15", "chr16", "chr17", "chr18", "chr19", "chr20", "chr21", "chr22")
pp <- getDefaultPlotParams(plot.type=4)
pp$ideogramlateralmargin = 0 
pp$ideogramheight = 0
pp$data1inmargin = -7
pp$leftmargin <- 0.1
plot.new()
kp <- plotKaryotype("hg38", plot.type=4, ideogram.plotter = NULL, labels.plotter = NULL,
                    chromosomes = chr_plot, main = " ", cex=1.5, plot.params = pp)
# bottom plot
kpPlotManhattan(kp, data = meta_gr, r0=autotrack(1,2, margin = 0.15),genomewideline = -log10(5e-8),
                suggestiveline = -log10(1e-5), , suggestive.col = "blue",
                genomewide.col = "red", ymax=48)
kpAddLabels(kp, labels = "Sex-meta", srt=90, pos=3, r0=autotrack(1,2, margin = 0.15), cex=2, label.margin = 0.055)
kpAddLabels(kp, labels = "-log10( p-value )", srt=90, pos=3, r0=autotrack(1,2, margin = 0.15), cex=1.5, label.margin = 0.039)
kpAxis(kp, ymin=0, ymax=48, r0=autotrack(1,2 , margin = 0.15), tick.number = 6)

# middle plot
kpPlotManhattan(kp, data = ns_gr, r0=autotrack(2,2, margin = 0.15),genomewideline = -log10(5e-8),
                suggestiveline = -log10(1e-5), , suggestive.col = "blue",
                genomewide.col = "red", ymax=48)
kpAddLabels(kp, labels = "Joint", srt=90, pos=3, r0=autotrack(2,2, margin = 0.15), cex=2, label.margin = 0.055)
kpAddLabels(kp, labels = "-log10( p-value )", srt=90, pos=3, r0=autotrack(2,2, margin = 0.15), cex=1.5, label.margin = 0.039)
kpAxis(kp, ymin=0, ymax=48, r0=autotrack(2,2,  margin = 0.15), tick.number = 6)
kpAddChromosomeNames(kp, srt=45, cex = 1)

invisible( dev.off() )



par(mfrow=c(4,3), mar=c(2,2,2,2))
hist(df_all$p.value, main = "SAIGE joint analysis (n = 4482)", col = "lightgray")
qq(df_all$p.value)
manhattan(df_all %>% select(everything(), BP = POS, P = p.value, SNP = MarkerID) %>% drop_na())
# meta
hist(df_meta_sex$P.value, main = "METAL sex meta analysis (n = 4482)", col = "lightgray")


