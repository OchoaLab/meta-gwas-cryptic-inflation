library(SAIGE)
library(optparse) 

dir = "/hpc/group/ochoalab/tgp-nygc-autosomes_ld_prune_1000kb_0.3_maf-0.01"
setwd(dir)
# terminal inputs
option_list = list(
  make_option(c( "-a", "--analysis"), type = "character", default = NA, 
              help = "subanalysis: all, subpop, sex", metavar = "character"),
  make_option(c( "-n", "--num"), type = "character", default = '1', 
              help = "numeric number that indicates number of rep", metavar = "character"),
  make_option(c( "-s", "--subanalysis"), type = "character", default = NA, 
              help = "all, male, female, afr, eur, ...", metavar = "character")
  
)

opt_parser <- OptionParser(option_list = option_list)
opt <- parse_args(opt_parser)
# get values
analysis <- opt$analysis # all
rep_num <- opt$num # '1'
sub <- opt$subanalysis



# load saige inputs

if (analysis != 'all') {
  if (analysis == "sex") {
    plinkFile = paste0("data_", sub) 
    phenoFile= paste0('rep-', rep_num, '/covar_saige_', sub, '.txt')
    outputPrefix= paste0('rep-', rep_num, '/saige_binary_', sub) 
    covars=c("major_ancestry", "PCs.1","PCs.2","PCs.3","PCs.4","PCs.5","PCs.6","PCs.7","PCs.8","PCs.9","PCs.10")
    qcovars = "major_ancestry"

    
  } else {
    # subpop
    plinkFile = paste0("data_", sub) 
    phenoFile= paste0('rep-', rep_num, '/covar_saige_', sub, '.txt')
    outputPrefix= paste0('rep-', rep_num,  '/saige_binary_', sub) 
    covars=c( 'sex',"major_ancestry", "PCs.1","PCs.2","PCs.3","PCs.4","PCs.5","PCs.6","PCs.7","PCs.8","PCs.9","PCs.10")
    # categorical
    qcovars=c('sex', "major_ancestry")
  }
  
} else {
  # else: main analysis (all individuals) 
  plinkFile = "data"
  phenoFile= paste0('rep-', rep_num, '/covar_saige.txt')
  outputPrefix= paste0('rep-', rep_num, '/saige_binary') 
  # covariates for main + conditional 
  covars=c("major_ancestry", 'sex',"PCs.1","PCs.2","PCs.3","PCs.4","PCs.5","PCs.6","PCs.7","PCs.8","PCs.9","PCs.10")
  # categorical
  qcovars=c("major_ancestry", 'sex')

}
  


print('start saige step1')
print(plinkFile)
print(phenoFile)
print(outputPrefix)



phenoCol= "trait"
sampleIDColinphenoFile='id' 
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
