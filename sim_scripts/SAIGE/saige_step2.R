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
# get values
simulation <- opt$simulation # 'sim1'
analysis <- opt$analysis # all
filename <- opt$filename
rep_num <- opt$num # '1'

# load saige inputs
if (analysis != 'all') {
  if (analysis == "sex") {
    plinkFile = paste0(dir, simulation, '/rep', rep_num, "/sex/", filename)
    GMMATmodelFile = paste0(dir, simulation, '/rep', rep_num, '/sex/saige_binary_', filename, ".rda") 
    varianceRatioFile = paste0(dir, simulation, '/rep', rep_num, '/sex/saige_binary_', filename,".varianceRatio.txt") 
    SAIGEOutputFile = paste0(dir, simulation, '/rep', rep_num, '/sex/saige_output_', filename, '_new.txt') 
    
  } else { # subpop
    plinkFile = paste0(dir, simulation, '/rep', rep_num, "/subpop/", filename)
    GMMATmodelFile = paste0(dir, simulation, '/rep', rep_num, '/subpop/saige_binary_', filename, ".rda") 
    varianceRatioFile = paste0(dir, simulation, '/rep', rep_num, '/subpop/saige_binary_', filename,".varianceRatio.txt") 
    SAIGEOutputFile = paste0(dir, simulation, '/rep', rep_num, '/subpop/saige_output_', filename, '.txt') 
  }
  # main analysis
} else {
    plinkFile = paste0(dir, simulation, '/rep', rep_num, "/", filename)
    GMMATmodelFile = paste0(dir, simulation, '/rep', rep_num, '/saige_binary.rda') 
    varianceRatioFile = paste0(dir, simulation, '/rep', rep_num, "/saige_binary.varianceRatio.txt") 
    SAIGEOutputFile = paste0(dir, simulation, '/rep', rep_num, "/saige_output_new.txt") 
}
  

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