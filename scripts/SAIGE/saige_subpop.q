#!/bin/bash
#SBATCH -p ochoalab --account=ochoalab
#SBATCH --job-name=sim1_saige_subpop
#SBATCH --output=saige_sim1_%a_subpop.out
#SBATCH --array=1-10
#SBATCH --mem=220G
#SBATCH --ntasks-per-node=24
#SBATCH --mail-user=tiffany.tu@duke.edu
#SBATCH --mail-type=END,FAIL

input_value=$((SLURM_ARRAY_TASK_ID))

export LD_LIBRARY_PATH=/opt/apps/rhel8/lapack/lib64:$LD_LIBRARY_PATH
module load R/4.1.1-rhel8

# saige with binary traits
time Rscript saige_step1.R -s sim1 -a subpop -f 1G_3000n_100causal_500000m_S1 -n $input_value
time Rscript saige_step2.R -s sim1 -a subpop -f 1G_3000n_100causal_500000m_S1 -n $input_value
#
time Rscript saige_step1.R -s sim1 -a subpop -f 1G_3000n_100causal_500000m_S2 -n $input_value
time Rscript saige_step2.R -s sim1 -a subpop -f 1G_3000n_100causal_500000m_S2 -n $input_value
# #
time Rscript saige_step1.R -s sim1 -a subpop -f 1G_3000n_100causal_500000m_S3 -n $input_value
time Rscript saige_step2.R -s sim1 -a subpop -f 1G_3000n_100causal_500000m_S3 -n $input_value


##### sim2
# time Rscript saige_step1.R -s sim2 -a all -f 30G_sim2_merged
# time Rscript saige_step2.R -s sim2 -a all -f 30G_sim2_merged
# 
# time Rscript saige_step1.R -s sim2 -a subpop -f 30G_3000n_100causal_500000m_S1
# time Rscript saige_step2.R -s sim2 -a subpop -f 30G_3000n_100causal_500000m_S1
# #
# time Rscript saige_step1.R -s sim2 -a subpop -f 30G_3000n_100causal_500000m_S2
# time Rscript saige_step2.R -s sim2 -a subpop -f 30G_3000n_100causal_500000m_S2
# # #
# time Rscript saige_step1.R -s sim2 -a subpop -f 30G_3000n_100causal_500000m_S3
# time Rscript saige_step2.R -s sim2 -a subpop -f 30G_3000n_100causal_500000m_S3
# # #
# time Rscript saige_step1.R -s sim2 -a sex -f 30G_3000n_100causal_500000m_males
# time Rscript saige_step2.R -s sim2 -a sex -f 30G_3000n_100causal_500000m_males
# 
# time Rscript saige_step1.R -s sim2 -a sex -f 30G_3000n_100causal_500000m_females
# time Rscript saige_step2.R -s sim2 -a sex -f 30G_3000n_100causal_500000m_females


###### sim3
# time Rscript saige_step1.R -s sim3 -a all -f 30G_3000n_100causal_500000m
# time Rscript saige_step2.R -s sim3 -a all -f 30G_3000n_100causal_500000m

# time Rscript saige_step1.R -s sim3 -a subpop -f 30G_3000n_100causal_500000m_S1
# time Rscript saige_step2.R -s sim3 -a subpop -f 30G_3000n_100causal_500000m_S1
# #
# time Rscript saige_step1.R -s sim3 -a subpop -f 30G_3000n_100causal_500000m_S2
# time Rscript saige_step2.R -s sim3 -a subpop -f 30G_3000n_100causal_500000m_S2
# # #
# time Rscript saige_step1.R -s sim3 -a subpop -f 30G_3000n_100causal_500000m_S3
# time Rscript saige_step2.R -s sim3 -a subpop -f 30G_3000n_100causal_500000m_S3
# # #
# time Rscript saige_step1.R -s sim3 -a sex -f 30G_3000n_100causal_500000m_males
# time Rscript saige_step2.R -s sim3 -a sex -f 30G_3000n_100causal_500000m_males
#
# time Rscript saige_step1.R -s sim3 -a sex -f 30G_3000n_100causal_500000m_females
# time Rscript saige_step2.R -s sim3 -a sex -f 30G_3000n_100causal_500000m_females

###### sim4
# time Rscript saige_step1.R -s sim4 -a all -f 30G_3000n_100causal_500000m
# time Rscript saige_step2.R -s sim4 -a all -f 30G_3000n_100causal_500000m
# # #
# time Rscript saige_step1.R -s sim4 -a sex -f 30G_3000n_100causal_500000m_males
# time Rscript saige_step2.R -s sim4 -a sex -f 30G_3000n_100causal_500000m_males
# 
# time Rscript saige_step1.R -s sim4 -a sex -f 30G_3000n_100causal_500000m_females
# time Rscript saige_step2.R -s sim4 -a sex -f 30G_3000n_100causal_500000m_females

module unload R/4.1.1-rhel8
