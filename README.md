Current scripts are written for our simulated data for two scenarios (case 1) single generation with no family relatedness, and (case 2) 30 generations with relatedness within subpopulation.  

**Job scripts / pipeline for each method**
- `control_vs_control_af.q` : plink calculates AF for platform 1 & 2, then `control_vs_control_af.R` calculates LRT for list of user input p-values and classify SNPs into flip, remove, or keep. (Bottom of the R script includes visualization code for pre and post harmonization AF plots that is commented out).
- `control_vs_control_hwe.q` : plink calculates hwe for platform 1 & 2, then `hardy-combine.R` combines the two tables in the same format as AF-filter, to easily classify SNPs into flip, remove, or keep.
- `control_vs_control_saige_case1.q`, `control_vs_control_saige_case1.q`: involves files: `saige_step1.R`, `saige_step2.R`, `phase1_remove.R`, `phase2_flip.R`, `phase3_remove.R`

**Simulation scripts**
- `gen_pop_platform.q` : job script for simulating case 1 and case 2
  - case 1: Run `gen_pop_sim1.R` then `bias_geno.R`
  - case 2: Split case 1 simulation data by subpop for case 2 simulation. Run `gen_pop_sim2_step1.R`, `gen_pop_sim2_step2.R`, merge 3 subpop, then `gen_pop_sim2_step3.R` and `bias_geno.R` in this order.    
('gen_pop_sim' files have input parameter -n for replicate number and -s for simulation/case, either 1 or 2).  
('bias_geno.R' have input parameter -n for replicate number and -s for simulation/case, either 1 or 2, and -f for file name).   

**Evaluation metric**
- `eval_metric_af.R`, `eval_metric_hwe.Rmd`, `eval_metric_saige.Rmd` : calculates PR curve metrics for each approach
- `eval_metric.Rmd` : combines eval metrics from all approaches for visualization

**Plotting**
- `plot_saige.R`, `plot_af.R` : AF plots for simulated data
- `plots_af_ns.R`, `plot_lmm_ns.R`, `plot_hwe_ns.R` : AF plots for NS real data
- `pca_ns.Rmd` : PCA for real data before/after harmonization


```bash
time Rscript plot_af.R -s 1 -r 11 -p 1e-12 -m af
time Rscript plot_af.R -s 1 -r 11 -p 1e-12 -m hwe

time Rscript plot_af.R -s 1 -r 1 -p 1e-12 -m af
```
