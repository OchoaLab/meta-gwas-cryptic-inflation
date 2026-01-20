library(SAIGE)
library(optparse) 

option_list = list(
  make_option(c( "-s", "--sex"), type = "character", default = 'male', 
              help = "male or female", metavar = "character"),
  make_option(c( "-a", "--array"), type = "character", default = '1', 
              help = "numeric number that indicates number of rep", metavar = "character"),
  make_option(c( "-l", "--loco"), type = "character", default = '1', 
              help = "indicate use of LOCO; 1 = TRUE, 0 = FALSE", metavar = "character"))

opt_parser <- OptionParser(option_list = option_list)
opt <- parse_args(opt_parser)
# get values
sex <- opt$sex # 'male
rep_num <- opt$array # '1'
loco <- opt$loco

dir = paste0("/data/irb/biostatisticsbioinformatics/pro00108518/t2d-samafs/study2/exome_chip/cryptic-relatedness/sim_traits/rep_", rep_num)

phenoFile= paste0(dir, "/covar_simtrait.txt")
print(phenoFile)
covars=c("age", "PCs.1","PCs.2","PCs.3","PCs.4","PCs.5","PCs.6","PCs.7","PCs.8","PCs.9","PCs.10")
phenoCol= "simtrait"
sampleIDColinphenoFile='SUBJECT_ID' 
traitType='quantitative'        
IsOverwriteVarianceRatioFile=TRUE

print('start saige step1')
if(loco == 1){
  print('LOCO = TRUE')
  if (sex == "male") {
    outputPrefix= paste0(dir, '/simtrait_quant_male_loco') 
    plinkFile = "/data/irb/biostatisticsbioinformatics/pro00108518/t2d-samafs/study2/exome_chip/gwas_qc/exome_chip_qc_male"
  } else {
    outputPrefix= paste0(dir, '/simtrait_quant_female_loco') 
    plinkFile = "/data/irb/biostatisticsbioinformatics/pro00108518/t2d-samafs/study2/exome_chip/gwas_qc/exome_chip_qc_female"
  }
  print(plinkFile)
  print(outputPrefix)
  fitNULLGLMM(plinkFile = plinkFile,
              phenoFile = phenoFile,
              phenoCol = phenoCol,
              sampleIDColinphenoFile = sampleIDColinphenoFile,
              traitType = traitType,
              outputPrefix = outputPrefix,
              covarColList = covars,
              IsOverwriteVarianceRatioFile = TRUE,
              LOCO = TRUE,
              minMAFforGRM = 0,
              maxMissingRateforGRM = 1,
              invNormalize=TRUE,
              nThreads=4
  )
  
} else{
  print('LOCO = FALSE')
  if (sex == "male") {
    outputPrefix= paste0(dir, '/simtrait_quant_male') 
    plinkFile = "/data/irb/biostatisticsbioinformatics/pro00108518/t2d-samafs/study2/exome_chip/gwas_qc/exome_chip_qc_male"
  } else {
    outputPrefix= paste0(dir, '/simtrait_quant_female') 
    plinkFile = "/data/irb/biostatisticsbioinformatics/pro00108518/t2d-samafs/study2/exome_chip/gwas_qc/exome_chip_qc_female"
  }
  
  print(plinkFile)
  print(outputPrefix)
  
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
              invNormalize=TRUE,
              nThreads=4
  )
  
}




