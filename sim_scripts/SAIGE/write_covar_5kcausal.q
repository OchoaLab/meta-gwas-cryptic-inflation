#!/bin/bash
#SBATCH -p ochoalab --account=ochoalab
#SBATCH --job-name=write_covar_5kcausal
#SBATCH --output=write_covar_5kcausal_%a.out
#SBATCH --array=1-20
#SBATCH --mem=60G
#SBATCH --ntasks-per-node=12
#SBATCH --mail-user=tiffany.tu@duke.edu
#SBATCH --mail-type=END,FAIL

# Build SAIGE covariate files for the 5000causal data across all 4 sims.

input_value=$((SLURM_ARRAY_TASK_ID))

module load R/4.1.1-rhel8

# sim1 (1G)
time Rscript write_covar_5kcausal.R -s sim1_h08 \
    -f 1G_3000n_5000causal_500000m \
    -c 1G_covar_3000n_5000causal_500000m.txt \
    -n $input_value

# sim2 (30G)
time Rscript write_covar_5kcausal.R -s sim2_h08 \
    -f 30G_3000n_5000causal_500000m \
    -c 30G_covar_3000n_5000causal_500000m_fes.txt \
    -n $input_value

# sim3 (30G)
time Rscript write_covar_5kcausal.R -s sim3_h08 \
    -f 30G_3000n_5000causal_500000m \
    -c 30G_covar_3000n_5000causal_500000m_fes.txt \
    -n $input_value

# sim4 (30G)
time Rscript write_covar_5kcausal.R -s sim4_h08 \
    -f 30G_3000n_5000causal_500000m \
    -c 30G_covar_3000n_5000causal_500000m_fes.txt \
    -n $input_value

module unload R/4.1.1-rhel8
