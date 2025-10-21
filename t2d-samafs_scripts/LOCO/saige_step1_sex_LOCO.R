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

dir = "/home/tt207/pro00108518/t2d-samafs/study2/exome_chip/cryptic-relatedness/saige_loco/sex/"


phenoFile= paste0("/home/tt207/pro00108518/t2d-samafs/study2/exome_chip/cryptic-relatedness/covar_t2d_t2d_age.txt")

if (sex == "male") {
  outputPrefix= paste0(dir, 't2d_binary_male_t2d_age_loco') 
  plinkFile = "/home/tt207/pro00108518/t2d-samafs/study2/exome_chip/gwas_qc/exome_chip_qc_male"
} else {
  outputPrefix= paste0(dir, 't2d_binary_female_t2d_age_loco') 
  plinkFile = "/home/tt207/pro00108518/t2d-samafs/study2/exome_chip/gwas_qc/exome_chip_qc_female"
}



# covariates for main + conditional 
covars=c( "t2d", "T2D_AGE", "PCs.1","PCs.2","PCs.3","PCs.4","PCs.5","PCs.6","PCs.7","PCs.8","PCs.9","PCs.10")


print('start saige step1')
print(plinkFile)
print(phenoFile)
print(outputPrefix)



phenoCol= "t2d"
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
            #qCovarCol = qcovars,
            IsOverwriteVarianceRatioFile = TRUE,
            LOCO = TRUE,
            nThreads=4,
            sexCol = "sex",
            minMAFforGRM = 0,
            maxMissingRateforGRM = 1
)
