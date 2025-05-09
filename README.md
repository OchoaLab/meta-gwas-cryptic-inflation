For this project, we evaluate confounding due to cryptic relatedness in genetic association meta-analysis using simulated data of varying population structure and family relatedness scenarios and real data from SAMAFS and HCHS-SOL. Additionally, using simulated kinship matrices, we show that the variance in between-study kinship values empirically scales with substudy sample size and increases with heritability and $F_{st}$. 

**Folders**
- Simulated data results are in `sim_scripts` folder
- Real data results
  - San Antonio Mexican American Family Studies (SAMAFS) Project 2 (dbGaP accession phs000847.v2.p1) : `t2d-samafs_scripts`
  - The Hispanic Community Healthy Study/Study of Latinos (HCHS/SOL) (dbGaP accession phs000810.v2.p2) : `hchs-sol_scripts`
  - 1000 Genomes Project with simulated traits: `tgp_scripts`
- `figures` folder : SAMAFS and HCHS/SOL phenotype distribution plots
- `data` folder : scripts & data for theory figures

**Simulated data and real data analysis scripts**
- Joint analysis: SAIGE (`saige_quant.q` and `saige_binary.q`)
- Sex stratified gwas: (`./sex/saige_quant.q` and `./sex/saige_binary.q`)
- Sex-stratified meta-analysis: (`./METAL/meta_sex.q`)
