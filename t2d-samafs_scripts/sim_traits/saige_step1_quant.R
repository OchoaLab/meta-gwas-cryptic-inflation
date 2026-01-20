library(SAIGE)
library(optparse) 

option_list = list(
  make_option(c( "-a", "--array"), type = "character", default = '1', 
              help = "numeric number that indicates number of rep", metavar = "character"),
  make_option(c( "-l", "--loco"), type = "character", default = '1', 
              help = "indicate use of LOCO; 1 = TRUE, 0 = FALSE", metavar = "character"))

opt_parser <- OptionParser(option_list = option_list)
opt <- parse_args(opt_parser)
# get values
rep_num <- opt$array # '1'
loco <- opt$loco

dir = paste0("/data/irb/biostatisticsbioinformatics/pro00108518/t2d-samafs/study2/exome_chip/cryptic-relatedness/sim_traits/rep_", rep_num)
phenoFile= paste0(dir, "/covar_simtrait.txt")

plinkFile = "/home/tt207/pro00108518/t2d-samafs/study2/exome_chip/exome_chip_qc"

# covariates for main + conditional 
covars=c('sex', "age", "PCs.1","PCs.2","PCs.3","PCs.4","PCs.5","PCs.6","PCs.7","PCs.8","PCs.9","PCs.10")
qcovars='sex'

print('start saige step1')
print(plinkFile)
print(phenoFile)


phenoCol= "simtrait"
sampleIDColinphenoFile='SUBJECT_ID' 
traitType='quantitative'        
IsOverwriteVarianceRatioFile=TRUE

if(loco == 1){
  print('LOCO == TRUE')
  outputPrefix= paste0(dir,'/simtrait_quant_simtrait_loco') 
  print(outputPrefix)
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
              minMAFforGRM = 0,
              maxMissingRateforGRM = 1,
              invNormalize=TRUE,
              nThreads=4
  )
  
} else{
  print('LOCO == FALSE')
  outputPrefix= paste0(dir,'/simtrait_quant_simtrait') 
  print(outputPrefix)
  fitNULLGLMM(plinkFile = plinkFile,
              phenoFile = phenoFile,
              phenoCol = phenoCol,
              sampleIDColinphenoFile = sampleIDColinphenoFile,
              traitType = traitType,
              LOCO = FALSE,
              outputPrefix = outputPrefix,
              covarColList = covars,
              qCovarCol = qcovars,
              IsOverwriteVarianceRatioFile = TRUE,
              sexCol = "sex",
              minMAFforGRM = 0,
              maxMissingRateforGRM = 1,
              invNormalize=TRUE,
              nThreads=4
  )
  
  
}


