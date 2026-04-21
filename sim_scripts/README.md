### Characterizing the effect of between-study relatedness:
- `main_sim1-4.bash`: overview of simulation structure for our 4 simulations scenarios
- Each simulation is generated with `sim1_gen_pop.q`, `sim2_gen_pop.q`, `sim3_gen_pop.q`, `sim4_gen_pop.q` separately. 
- famid / individual stored in `S1-1.txt`, `S1-2.txt`, `S1-3.txt`, `S1.txt`, `S2.txt`, `S3.txt` for the purpose of splitting data by subpopulation. 
- Evaluation metrics (inflation factor, srmsd, auc, gc) is calculated separately for binary and quantitative trait analyses: `eval_metric_gc_binary.R`, `eval_metric_gc_quant.R`
- Plotting final evaluation metric results: `./figures/plot_eval_GC.R`

### Sample size evaluation:
Using existing scripts for sim4 (single population generated for 30 generations), we increase the founder sample size to n = 10,000 and subsequently subset to n = 8000, 6000, 4000, and 2000.
- Perform joint quantitative trait GWAS and sex-stratified meta-analysis using existing SAIGE and METAL scripts: `samplesize_eval_metric.R`, `samplesize_subset_covar.R`, `samplesize_subset_plink.q`, `samplesize_subset_plink.R`, `samplesize_write_covar.R`
- We further compared cdf of kinship estimate for sim4 with founder of 3000 vs subsetting to 3000: `./figures/kinship_comparison.R`; eval figure: `./figures/samplesize_plot_eval.R`
