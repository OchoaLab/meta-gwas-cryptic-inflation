library(SAIGE)

dir = "/hpc/group/ochoalab/tt207/meta_analysis_aim/samafs/saige/"


# load saige inputs


plinkFile = "/datacommons/ochoalab/t2d-samafs/study2/exome_chip/gwas_qc/exome_chip_qc"
phenoFile= "/datacommons/ochoalab/t2d-samafs/study2/exome_chip/gwas_qc/covar_t2d_t2d_age.txt"

GMMATmodelFile = paste0(dir, 't2d_binary_t2d_age.rda') 
varianceRatioFile = paste0(dir,"t2d_binary_t2d_age.varianceRatio.txt") 
SAIGEOutputFile = paste0(dir, "saige_output_t2d_t2d_age.txt") 

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