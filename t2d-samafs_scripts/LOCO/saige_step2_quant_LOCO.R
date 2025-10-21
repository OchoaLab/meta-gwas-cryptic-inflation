library(SAIGE)
library(optparse) 

dir = "/home/tt207/pro00108518/t2d-samafs/study2/exome_chip/cryptic-relatedness/saige_loco/"

option_list = list(
  make_option(c( "-t", "--trait"), type = "character", default = 'height', 
              help = "trait name", metavar = "character"),
  make_option(c( "-a", "--age"), type = "character", default = "HEIGHT_AGE", 
              help = "additional age covar name", metavar = "character"),
  make_option(c( "-c", "--chr"), type = "character", default = '1', 
              help = "chromosome number of LOCO", metavar = "character")
)

opt_parser <- OptionParser(option_list = option_list)
opt <- parse_args(opt_parser)
# get values
trait <- opt$trait
age <- opt$age
chrom <- opt$chr
# load saige inputs


plinkFile = "/home/tt207/pro00108518/t2d-samafs/study2/exome_chip/exome_chip_qc"
phenoFile=paste0("/home/tt207/pro00108518/t2d-samafs/study2/exome_chip/cryptic-relatedness/covar_", trait, "_trait_age.txt")

GMMATmodelFile = paste0(dir, trait, '_quant_trait_age_loco.rda') 
varianceRatioFile = paste0(dir, trait, "_quant_trait_age_loco.varianceRatio.txt") 
SAIGEOutputFile = paste0(dir, "saige_output_", trait, "_trait_age_loco_chr", chrom, ".txt") 

print( 'saige step 2')
print(plinkFile)
print(GMMATmodelFile)
print(varianceRatioFile)
print(SAIGEOutputFile)

SPAGMMATtest(bedFile=paste0(plinkFile, ".bed"),
             bimFile=paste0(plinkFile, ".bim"),
             famFile=paste0(plinkFile, ".fam"),
             AlleleOrder= 'alt-first',
             is_imputed_data=FALSE,
             #impute_method = opt$impute_method,
             GMMATmodelFile=GMMATmodelFile,
             varianceRatioFile=varianceRatioFile,
             SAIGEOutputFile=SAIGEOutputFile,
             is_output_moreDetails =TRUE,
             is_overwrite_output = TRUE,
             #SPAcutoff = opt$SPAcutoff, default 2
             is_Firth_beta = FALSE, # for binary traits
             #pCutoffforFirth = 1, # default 0.01
             LOCO = TRUE,
             chrom = chrom,
             min_MAF=0,
             min_MAC=0.5,
             max_missing = 1,
             dosage_zerod_cutoff = 0,
             dosage_zerod_MAC_cutoff = 0
             
)

