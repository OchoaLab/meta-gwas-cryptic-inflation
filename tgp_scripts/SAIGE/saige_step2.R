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
    plinkFile =paste0("data_", sub) 
    GMMATmodelFile = paste0('rep-', rep_num, '/saige_binary_', sub, ".rda") 
    varianceRatioFile = paste0('rep-', rep_num, '/saige_binary_', sub,".varianceRatio.txt") 
    SAIGEOutputFile = paste0('rep-', rep_num, '/saige_output_', sub, '.txt') 
    
  } else { # subpop
    plinkFile = paste0("data_", sub) 
    GMMATmodelFile = paste0('rep-', rep_num, '/saige_binary_', sub, ".rda") 
    varianceRatioFile = paste0('rep-', rep_num, '/saige_binary_', sub,".varianceRatio.txt") 
    SAIGEOutputFile = paste0('rep-', rep_num, '/saige_output_', sub, '.txt') 
  }
  # main analysis
} else {
    plinkFile = "data"
    GMMATmodelFile = paste0('rep-', rep_num, '/saige_binary.rda') 
    varianceRatioFile = paste0('rep-', rep_num, "/saige_binary.varianceRatio.txt") 
    SAIGEOutputFile = paste0('rep-', rep_num, "/saige_output.txt") 
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