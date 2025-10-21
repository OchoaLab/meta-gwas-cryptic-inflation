library(SAIGE)
library(optparse) 

option_list = list(
  make_option(c( "-s", "--sex"), type = "character", default = 'male', 
              help = "male or female", metavar = "character"),
  make_option(c( "-c", "--chr"), type = "character", default = '1', 
              help = "chromosome number of LOCO", metavar = "character")
)

opt_parser <- OptionParser(option_list = option_list)
opt <- parse_args(opt_parser)
# get values
sex <- opt$sex # 'male
chrom <- opt$chr

dir = "/home/tt207/pro00108518/t2d-samafs/study2/exome_chip/cryptic-relatedness/saige_loco/sex/"


phenoFile= paste0("/home/tt207/pro00108518/t2d-samafs/study2/exome_chip/cryptic-relatedness/covar_t2d_t2d_age.txt")


# load saige inputs
if (sex == "male") {
  plinkFile = "/home/tt207/pro00108518/t2d-samafs/study2/exome_chip/gwas_qc/exome_chip_qc_male"
  GMMATmodelFile = paste0(dir, 't2d_binary_male_t2d_age_loco.rda') 
  varianceRatioFile = paste0(dir,"t2d_binary_male_t2d_age_loco.varianceRatio.txt") 
  SAIGEOutputFile = paste0(dir, "saige_output_t2d_binary_male_t2d_age_loco_chr", chrom, ".txt") 
} else {
  plinkFile = "/home/tt207/pro00108518/t2d-samafs/study2/exome_chip/gwas_qc/exome_chip_qc_female"
  GMMATmodelFile = paste0(dir, 't2d_binary_female_t2d_age_loco.rda') 
  varianceRatioFile = paste0(dir,"t2d_binary_female_t2d_age_loco.varianceRatio.txt") 
  SAIGEOutputFile = paste0(dir, "saige_output_t2d_binary_female_t2d_age_loco_chr", chrom, ".txt") 
}




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