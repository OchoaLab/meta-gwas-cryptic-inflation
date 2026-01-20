library(SAIGE)
library(optparse) 

option_list = list(
  make_option(c( "-s", "--sex"), type = "character", default = 'male', 
              help = "male or female", metavar = "character"),
  make_option(c( "-a", "--array"), type = "character", default = '1', 
              help = "numeric number that indicates number of rep", metavar = "character"),
  make_option(c( "-l", "--loco"), type = "character", default = '1', 
              help = "indicate use of LOCO; 1 = TRUE, 0 = FALSE", metavar = "character"),
  make_option(c( "-c", "--chr"), type = "character", default = '1', 
              help = "chromosome number of LOCO", metavar = "character"))

opt_parser <- OptionParser(option_list = option_list)
opt <- parse_args(opt_parser)
# get values
sex <- opt$sex # 'male
rep_num <- opt$array
loco <- opt$loco
chrom <- opt$chr

dir = paste0("/data/irb/biostatisticsbioinformatics/pro00108518/t2d-samafs/study2/exome_chip/cryptic-relatedness/sim_traits/rep_", rep_num)
print( 'saige step 2')
phenoFile= paste0(dir, "/covar_simtrait.txt")

if(loco == 1){
  print('LOCO = TRUE')
    if (sex == "male") {
      plinkFile = "/data/irb/biostatisticsbioinformatics/pro00108518/t2d-samafs/study2/exome_chip/gwas_qc/exome_chip_qc_male"
      GMMATmodelFile = paste0(dir, '/simtrait_quant_male_loco.rda') 
      varianceRatioFile = paste0(dir, "/simtrait_quant_male_loco.varianceRatio.txt") 
      SAIGEOutputFile = paste0(dir, "/saige_output_simtrait_male_loco_chr", chrom, ".txt") 
      
    } else {
      plinkFile = "/data/irb/biostatisticsbioinformatics/pro00108518/t2d-samafs/study2/exome_chip/gwas_qc/exome_chip_qc_female"
      GMMATmodelFile = paste0(dir, '/simtrait_quant_female_loco.rda') 
      varianceRatioFile = paste0(dir, "/simtrait_quant_female_loco.varianceRatio.txt") 
      SAIGEOutputFile = paste0(dir, "/saige_output_simtrait_female_loco_chr", chrom, ".txt") 
    }
    
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
                 is_Firth_beta = FALSE, # for binary traits
                 #pCutoffforFirth = 1, # default 0.01
                 LOCO = TRUE,
                 chrom=chrom,
                 min_MAF=0,
                 min_MAC=0.5,
                 max_missing = 1,
                 dosage_zerod_cutoff = 0,
                 dosage_zerod_MAC_cutoff = 0
                 
    )
  
    
  } else {
    print('LOCO = FALSE')
    if (sex == "male") {
      plinkFile = "/data/irb/biostatisticsbioinformatics/pro00108518/t2d-samafs/study2/exome_chip/gwas_qc/exome_chip_qc_male"
      GMMATmodelFile = paste0(dir, '/simtrait_quant_male.rda') 
      varianceRatioFile = paste0(dir, "/simtrait_quant_male.varianceRatio.txt") 
      SAIGEOutputFile = paste0(dir, "/saige_output_simtrait_male.txt") 
      
    } else {
      plinkFile = "/data/irb/biostatisticsbioinformatics/pro00108518/t2d-samafs/study2/exome_chip/gwas_qc/exome_chip_qc_female"
      GMMATmodelFile = paste0(dir, '/simtrait_quant_female.rda') 
      varianceRatioFile = paste0(dir, "/simtrait_quant_female.varianceRatio.txt") 
      SAIGEOutputFile = paste0(dir, "/saige_output_simtrait_female.txt") 
    }
    
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
                 is_Firth_beta = FALSE, # for binary traits
                 #pCutoffforFirth = 1, # default 0.01
                 LOCO = FALSE,
                 min_MAF=0,
                 min_MAC=0.5,
                 max_missing = 1,
                 dosage_zerod_cutoff = 0,
                 dosage_zerod_MAC_cutoff = 0
                 
    )
    
  }
  
  





