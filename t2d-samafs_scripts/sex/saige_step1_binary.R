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


phenoFile= "/datacommons/ochoalab/t2d-samafs/study2/exome_chip/gwas_qc/covar_a2h_glu_a2h_glu_age.txt"

if (sex == "male") {
  outputPrefix= paste0(dir, 't2d_binary_male_a2h_glu_age') 
  plinkFile = "/datacommons/ochoalab/t2d-samafs/study2/exome_chip/gwas_qc/exome_chip_qc_male"
} else {
  outputPrefix= paste0(dir, 't2d_binary_female_a2h_glu_age') 
  plinkFile = "/datacommons/ochoalab/t2d-samafs/study2/exome_chip/gwas_qc/exome_chip_qc_female"
}



# covariates for main + conditional 
covars=c( "A2H_GLU_AGE", "PCs.1","PCs.2","PCs.3","PCs.4","PCs.5","PCs.6","PCs.7","PCs.8","PCs.9","PCs.10")


print('start saige step1')
print(plinkFile)
print(phenoFile)
print(outputPrefix)



phenoCol= "a2h_glu"
sampleIDColinphenoFile='SUBJECT_ID' 
traitType='binary'        
IsOverwriteVarianceRatioFile=TRUE

fitNULLGLMM(plinkFile = plinkFile,
            phenoFile = phenoFile,
            phenoCol = phenoCol,
            sampleIDColinphenoFile = sampleIDColinphenoFile,
            traitType = traitType,
            outputPrefix = outputPrefix,
            covarColList = covars,
            qCovarCol = qcovars,
            IsOverwriteVarianceRatioFile = TRUE,
            LOCO = FALSE,
            sexCol = "sex",
            minMAFforGRM = 0,
            maxMissingRateforGRM = 1
)
