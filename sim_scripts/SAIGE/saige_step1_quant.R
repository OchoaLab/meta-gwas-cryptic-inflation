library(SAIGE)
library(optparse) 

dir = "/hpc/group/ochoalab/tt207/meta_analysis_aim/"

# terminal inputs
option_list = list(
  make_option(c( "-s", "--simulation"), type = "character", default = 'sim1', 
              help = "simulation: sim1, sim2, sim3, sim4", metavar = "character"),
  make_option(c( "-a", "--analysis"), type = "character", default = NA, 
              help = "subanalysis: all, subpop, sex", metavar = "character"),
  make_option(c( "-f", "--filename"), type = "character", default = NA, 
              help = "filename/plink file", metavar = "character"),
  make_option(c( "-n", "--num"), type = "character", default = '1', 
              help = "numeric number that indicates number of rep", metavar = "character")
  
)

opt_parser <- OptionParser(option_list = option_list)
opt <- parse_args(opt_parser)
# get values
simulation <- opt$simulation # 'sim1'
analysis <- opt$analysis # all
filename <- opt$filename
rep_num <- opt$num # '1'

print(simulation)
print(analysis)

# load saige inputs

if (analysis != 'all') {
  if (analysis == "sex") {
    plinkFile = paste0(dir, simulation, '/rep', rep_num, "/sex/", filename)
    phenoFile= paste0(dir, simulation, '/rep', rep_num, '/sex/covar_saige_', filename, '_quant.txt')
    outputPrefix= paste0(dir, simulation, '/rep', rep_num, '/sex/saige_quant_', filename) 
    covars=c( "PCs.1","PCs.2","PCs.3","PCs.4","PCs.5","PCs.6","PCs.7","PCs.8","PCs.9","PCs.10")
    
    #covars=c('famid', "PCs.1","PCs.2","PCs.3","PCs.4","PCs.5","PCs.6","PCs.7","PCs.8","PCs.9","PCs.10")
    #qcovars = "famid"

    
  } else {
    # subpop
    plinkFile = paste0(dir, simulation, '/rep', rep_num, "/subpop/", filename)
    phenoFile= paste0(dir, simulation, '/rep', rep_num, '/subpop/covar_saige_', filename, '_quant.txt')
    outputPrefix= paste0(dir, simulation,'/rep', rep_num,  '/subpop/saige_quant_', filename) 
    covars=c('sex', "PCs.1","PCs.2","PCs.3","PCs.4","PCs.5","PCs.6","PCs.7","PCs.8","PCs.9","PCs.10")
    # categorical
    qcovars='sex'
  }
  
} else {
  # else: main analysis (all individuals) 
  plinkFile = paste0(dir, simulation,'/rep', rep_num, "/", filename)
  phenoFile= paste0(dir, simulation,'/rep', rep_num, '/covar_saige_', filename, '_quant.txt')
  outputPrefix= paste0(dir, simulation,'/rep', rep_num, '/saige_quant') 
  # covariates for main + conditional 
  covars=c('sex', "PCs.1","PCs.2","PCs.3","PCs.4","PCs.5","PCs.6","PCs.7","PCs.8","PCs.9","PCs.10")
  qcovars='sex'
  #covars=c('sex', 'famid', "PCs.1","PCs.2","PCs.3","PCs.4","PCs.5","PCs.6","PCs.7","PCs.8","PCs.9","PCs.10")
  # categorical
  #qcovars=c('sex', 'famid')

}
  


print('start saige step1')
print(plinkFile)
print(phenoFile)
print(outputPrefix)



phenoCol= "trait"
sampleIDColinphenoFile='id' 
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
            maxMissingRateforGRM = 1
)
