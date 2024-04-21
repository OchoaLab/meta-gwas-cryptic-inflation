# sim1: 3 subpop with no family relatedness, 1 generation
# sim2: 3 subpop with family relatedness within subpop, 30 generation
# sim3: 3 subpop with family relatedness across subpop, 30 generations
# sim4: 1 population with family relatedness, 30 generations

# h^2 = 0.8, 20 replicates, fes = TRUE, Fst = 0.3
# 500,000 loci, 3000 individuals, 100 causal variants

## simulation 1: 
mkdir sim1_h08
#array job for 20 replicates: sim1_gen_pop.q (simulate, split data into male/female & S1/S2/S3, and compute PCs)

## simulation 2: 
mkdir sim2_h08
#array job for 20 replicates: sim2_gen_pop.q, sim2_grm.q

## simulation 3: 
mkdir sim3_h08
#array job for 20 replicates: sim3_gen_pop.q, sim3_grm.q

## simulation 4: 
mkdir sim4_h08
#array job for 20 replicates: sim4_gen_pop.q, sim4_grm.q
#additional test for sim4 subpop (no population structure): sim4_split.q (split data into S1, S2, S3 and compute PCs)

# Now data for each simulation is generated, PCs computed, we can write covariate files for SAIGE.
# move into SAIGE directory -> array job for 20 replicates, run separately for each simulation: write_covar.q
# covar files write into each replicate folder in each simulation directory.

# run SAIGE for each simulation separately, array job for 20 replicates: saige.q, saige_subpop.q
# (split into two .q files to run in parallel, saige.q includes joint analysis and male/female subanalyses)
# saige output files write into each replicate folder in each simulation directory.

# After SAIGE is complete, move into METAL directory
mkdir ./METAL/sim1_h08
mkdir ./METAL/sim2_h08
mkdir ./METAL/sim3_h08
mkdir ./METAL/sim4_h08

# run array job for 20 replicates for each simulation: meta_sex.q, meta_sim1_subpop.q, meta_sim2_subpop.q, meta_sim3_subpop.q, meta_sim4_subpop.q
# metal output files write into each simulation directory within METAL folder.

# compute evaluation metrics, run for each simulation: eval_metric.q
