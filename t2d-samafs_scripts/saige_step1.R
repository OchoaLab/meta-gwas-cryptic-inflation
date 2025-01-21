library(SAIGE)


dir = "/hpc/group/ochoalab/tt207/meta_analysis_aim/samafs/saige/"


plinkFile = "/datacommons/ochoalab/t2d-samafs/study2/exome_chip/gwas_qc/exome_chip_qc"
phenoFile= "/datacommons/ochoalab/t2d-samafs/study2/exome_chip/gwas_qc/covar_t2d_t2d_age.txt"
outputPrefix= paste0(dir, 't2d_binary_t2d_age') 
# covariates for main + conditional 
covars=c('sex',"T2D_AGE", "PCs.1","PCs.2","PCs.3","PCs.4","PCs.5","PCs.6","PCs.7","PCs.8","PCs.9","PCs.10")
qcovars='sex'

print('start saige step1')
print(plinkFile)
print(phenoFile)
print(outputPrefix)



phenoCol= "t2d"
sampleIDColinphenoFile='SUBJECT_ID' 
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
