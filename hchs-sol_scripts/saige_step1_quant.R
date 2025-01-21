library(SAIGE)
library(optparse) 

dir = "/hpc/dctrl/tt207/meta_analysis_aim/hchs-sol/saige/"

option_list = list(
  make_option(c( "-t", "--trait"), type = "character", default = 'height', 
              help = "trait name", metavar = "character"))

opt_parser <- OptionParser(option_list = option_list)
opt <- parse_args(opt_parser)
# get values
trait <- opt$trait

plinkFile = "/hpc/group/ochoalab/zh105/project2/hchs-sol/Ia/data_qc"
phenoFile= paste0("/hpc/group/ochoalab/tt207/meta_analysis_aim/hchs-sol/covar_", trait, "_trait.txt")
outputPrefix= paste0(dir, trait, '_quant_trait') 
# covariates for main + conditional 
covars=c('sex', "PCs.1","PCs.2","PCs.3","PCs.4","PCs.5","PCs.6","PCs.7","PCs.8","PCs.9","PCs.10")
qcovars='sex'

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
            qCovarCol = qcovars,
            IsOverwriteVarianceRatioFile = TRUE,
            LOCO = FALSE,
            sexCol = "sex",
            minMAFforGRM = 0,
            maxMissingRateforGRM = 1,
            invNormalize=TRUE
)
