library(SAIGE)
library(optparse) 

dir = "/home/tt207/pro00108518/hchs-sol/Ia/cryptic-relatedness/saige_loco/"

option_list = list(
  make_option(c( "-t", "--trait"), type = "character", default = 'height', 
              help = "trait name", metavar = "character"))

opt_parser <- OptionParser(option_list = option_list)
opt <- parse_args(opt_parser)
# get values
trait <- opt$trait

plinkFile = "/data/irb/biostatisticsbioinformatics/pro00108518/hchs-sol/Ia/data_qc"
phenoFile= paste0("/home/tt207/pro00108518/hchs-sol/Ia/cryptic-relatedness/covar_", trait, "_trait.txt")
outputPrefix= paste0(dir, trait, '_quant_trait_LOCO') 
# covariates for main + conditional 
covars=c('sex', "age", "PCs.1","PCs.2","PCs.3","PCs.4","PCs.5","PCs.6","PCs.7","PCs.8","PCs.9","PCs.10")
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
            sexCol = "sex",
            LOCO = TRUE,
            minMAFforGRM = 0,
            maxMissingRateforGRM = 1,
            invNormalize=TRUE,
            nThreads=4
)
