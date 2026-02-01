For this project, we evaluate confounding due to cryptic relatedness in genetic association meta-analysis using simulated data of varying population structure and family relatedness scenarios and real data from SAMAFS and HCHS-SOL. Additionally, using simulated kinship matrices, we show that the variance in between-study kinship values empirically scales with substudy sample size and increases with heritability and $F_{st}$. 

**Folders**
- Simulated data results are in `sim_scripts` folder
- Real data results
  - San Antonio Mexican American Family Studies (SAMAFS) Project 2 (dbGaP accession phs000847.v2.p1) : `t2d-samafs_scripts`
  - The Hispanic Community Healthy Study/Study of Latinos (HCHS/SOL) (dbGaP accession phs000810.v2.p2) : `hchs-sol_scripts`
- `figures` folder : scripts for generating manuscript figures
- `data` folder : scripts & data for theory figures

**Simulated data and real data analysis scripts**
- Joint analysis: SAIGE (`saige_quant.q` and `saige_binary.q`)
- Sex stratified gwas: (`./sex/saige_quant.q` and `./sex/saige_binary.q`)
- Sex-stratified meta-analysis: (`./METAL/meta_sex.q`)

**Simulated traits with real data genotypes**
`t2d-samafs_scripts/sim_traits/` and `hchs-sol_scripts/sim_traits/`
* `draw_trait.q`, `draw_trait.R`: draw simulated traits with m_causal = 1000 and heritability = 0.8. This script also creates covariate file with PCs for SAIGE
* `causal_snp_masking.R`: masking causal SNPs with a window of 1000000 (can be adjusted)
* `saige_quant.q`, `saige_quant_male_step1.q`, `saige_quant_male_step2.q`, `saige_quant_female_step1.q`, `saige_quant_female_step2.q` : option for LOCO or no LOCO
* `combine_chrom_loco.q`: for LOCO results, outputs are written per chromosome and need to be combined before evaluation. 
* `create_metal_file.q`, `meta_sex.q`: generate sex-meta analysis scripts for METAL and run sex-meta analysis
