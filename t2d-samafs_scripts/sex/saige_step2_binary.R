library(SAIGE)
library(optparse) 

option_list = list(
  make_option(c( "-s", "--sex"), type = "character", default = 'male', 
              help = "male or female", metavar = "character")
)

opt_parser <- OptionParser(option_list = option_list)
opt <- parse_args(opt_parser)
# get values
sex <- opt$sex # 'male

dir = "/hpc/group/ochoalab/tt207/meta_analysis_aim/samafs/saige/sex/"


# load saige inputs
if (sex == "male") {
  plinkFile = "/datacommons/ochoalab/t2d-samafs/study2/exome_chip/gwas_qc/exome_chip_qc_male"
  GMMATmodelFile = paste0(dir, 't2d_binary_male_a2h_glu_age.rda') 
  varianceRatioFile = paste0(dir,"t2d_binary_male_a2h_glu_age.varianceRatio.txt") 
  SAIGEOutputFile = paste0(dir, "saige_output_a2h_glu_male_a2h_glu_age.txt") 
} else {
  plinkFile = "/datacommons/ochoalab/t2d-samafs/study2/exome_chip/gwas_qc/exome_chip_qc_female"
  GMMATmodelFile = paste0(dir, 't2d_binary_female_a2h_glu_age.rda') 
  varianceRatioFile = paste0(dir,"t2d_binary_female_t2d_age.varianceRatio.txt") 
  SAIGEOutputFile = paste0(dir, "saige_output_a2h_glu_female_a2h_glu_age.txt") 
}

phenoFile= "/datacommons/ochoalab/t2d-samafs/study2/exome_chip/gwas_qc/covar_a2h_glu_a2h_glu_age.txt"



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
             is_Firth_beta = TRUE, # for binary traits
             #pCutoffforFirth = 1, # default 0.01
             LOCO = FALSE,
             min_MAF=0,
             min_MAC=0.5,
             max_missing = 1,
             dosage_zerod_cutoff = 0,
             dosage_zerod_MAC_cutoff = 0
             
)