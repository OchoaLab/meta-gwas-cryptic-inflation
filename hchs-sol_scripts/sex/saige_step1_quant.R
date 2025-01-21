library(SAIGE)
library(optparse) 
dir = "/hpc/dctrl/tt207/meta_analysis_aim/hchs-sol/saige/"

option_list = list(
  make_option(c( "-s", "--sex"), type = "character", default = 'male', 
              help = "male or female", metavar = "character"),
  make_option(c( "-t", "--trait"), type = "character", default = 'height', 
              help = "trait name", metavar = "character"))

opt_parser <- OptionParser(option_list = option_list)
opt <- parse_args(opt_parser)
# get values
sex <- opt$sex # 'male
trait <- opt$trait


phenoFile= paste0("/hpc/group/ochoalab/tt207/meta_analysis_aim/hchs-sol/covar_", trait, "_trait.txt")

if (sex == "male") {
  outputPrefix= paste0(dir, trait, '_quant_male') 
  plinkFile = "/hpc/group/ochoalab/tt207/meta_analysis_aim/hchs-sol/sex/data_qc_male"
} else {
  outputPrefix= paste0(dir, trait, '_quant_female') 
  plinkFile = "/hpc/group/ochoalab/tt207/meta_analysis_aim/hchs-sol/sex/data_qc_female"
}

# covariates for main + conditional 
covars=c("PCs.1","PCs.2","PCs.3","PCs.4","PCs.5","PCs.6","PCs.7","PCs.8","PCs.9","PCs.10")


print('start saige step1')
print(plinkFile)
print(phenoFile)
print(outputPrefix)



phenoCol= trait
sampleIDColinphenoFile='SUBJECT_ID' 
traitType='quantitative'        
IsOverwriteVarianceRatioFile=TRUE

fitNULLGLMM(plinkFile = plinkFile,
            phenoFile = phenoFile,
            phenoCol = phenoCol,
            sampleIDColinphenoFile = sampleIDColinphenoFile,
            traitType = traitType,
            outputPrefix = outputPrefix,
            covarColList = covars,
            IsOverwriteVarianceRatioFile = TRUE,
            LOCO = FALSE,
            minMAFforGRM = 0,
            maxMissingRateforGRM = 1,
            invNormalize=TRUE
)
