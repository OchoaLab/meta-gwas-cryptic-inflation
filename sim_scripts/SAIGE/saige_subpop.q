#!/bin/bash
#SBATCH -p ochoalab --account=ochoalab
#SBATCH --job-name=sim4_saige_subpop
#SBATCH --output=saige_sim4_%a_subpop.out
#SBATCH --array=1-20
#SBATCH --mem=250G
#SBATCH --ntasks-per-node=24
#SBATCH --mail-user=tiffany.tu@duke.edu
#SBATCH --mail-type=END,FAIL

input_value=$((SLURM_ARRAY_TASK_ID))

export LD_LIBRARY_PATH=/opt/apps/rhel8/lapack/lib64:$LD_LIBRARY_PATH
module load R/4.1.1-rhel8

# saige with binary traits

# # sim1
# time Rscript saige_step1_fes.R -s sim1_h08 -a subpop -f 1G_3000n_100causal_500000m_S1 -n $input_value
# time Rscript saige_step2.R -s sim1_h08 -a subpop -f 1G_3000n_100causal_500000m_S1 -n $input_value
# #
# time Rscript saige_step1_fes.R -s sim1_h08 -a subpop -f 1G_3000n_100causal_500000m_S2 -n $input_value
# time Rscript saige_step2.R -s sim1_h08 -a subpop -f 1G_3000n_100causal_500000m_S2 -n $input_value
# # #
# time Rscript saige_step1_fes.R -s sim1_h08 -a subpop -f 1G_3000n_100causal_500000m_S3 -n $input_value
# time Rscript saige_step2.R -s sim1_h08 -a subpop -f 1G_3000n_100causal_500000m_S3 -n $input_value
# 
# # sim2
# 
# time Rscript saige_step1_fes.R -s sim1_h08 -a subpop -f 30G_3000n_100causal_500000m_S1 -n $input_value
# time Rscript saige_step2.R -s sim1_h08 -a subpop -f 30G_3000n_100causal_500000m_S1 -n $input_value
# #
# time Rscript saige_step1_fes.R -s sim1_h08 -a subpop -f 30G_3000n_100causal_500000m_S2 -n $input_value
# time Rscript saige_step2.R -s sim1_h08 -a subpop -f 30G_3000n_100causal_500000m_S2 -n $input_value
# # #
# time Rscript saige_step1_fes.R -s sim1_h08 -a subpop -f 30G_3000n_100causal_500000m_S3 -n $input_value
# time Rscript saige_step2.R -s sim1_h08 -a subpop -f 30G_3000n_100causal_500000m_S3 -n $input_value
# 
# # sim3
# time Rscript saige_step1_fes.R -s sim1_h08 -a subpop -f 30G_3000n_100causal_500000m_S1 -n $input_value
# time Rscript saige_step2.R -s sim1_h08 -a subpop -f 30G_3000n_100causal_500000m_S1 -n $input_value
# #
# time Rscript saige_step1_fes.R -s sim1_h08 -a subpop -f 30G_3000n_100causal_500000m_S2 -n $input_value
# time Rscript saige_step2.R -s sim1_h08 -a subpop -f 30G_3000n_100causal_500000m_S2 -n $input_value
# # #
# time Rscript saige_step1_fes.R -s sim1_h08 -a subpop -f 30G_3000n_100causal_500000m_S3 -n $input_value
# time Rscript saige_step2.R -s sim1_h08 -a subpop -f 30G_3000n_100causal_500000m_S3 -n $input_value

# sim4 
time Rscript saige_step1_fes.R -s sim4_h08 -a subpop -f 30G_3000n_100causal_500000m_S1 -n $input_value
time Rscript saige_step2.R -s sim4_h08 -a subpop -f 30G_3000n_100causal_500000m_S1 -n $input_value
#
time Rscript saige_step1_fes.R -s sim4_h08 -a subpop -f 30G_3000n_100causal_500000m_S2 -n $input_value
time Rscript saige_step2.R -s sim4_h08 -a subpop -f 30G_3000n_100causal_500000m_S2 -n $input_value
# #
time Rscript saige_step1_fes.R -s sim4_h08 -a subpop -f 30G_3000n_100causal_500000m_S3 -n $input_value
time Rscript saige_step2.R -s sim4_h08 -a subpop -f 30G_3000n_100causal_500000m_S3 -n $input_value


module unload R/4.1.1-rhel8
