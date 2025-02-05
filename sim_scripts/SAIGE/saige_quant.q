#!/bin/bash
#SBATCH -p ochoalab --account=ochoalab
#SBATCH --job-name=main.sim4_quant
#SBATCH --output=saige_sim4_%a_quant.out
#SBATCH --array=1-20
#SBATCH --mem=100G
#SBATCH --ntasks-per-node=24
#SBATCH --mail-user=tiffany.tu@duke.edu
#SBATCH --mail-type=END,FAIL

input_value=$((SLURM_ARRAY_TASK_ID))

export LD_LIBRARY_PATH=/opt/apps/rhel8/lapack/lib64:$LD_LIBRARY_PATH
module load R/4.1.1-rhel8

# saige with binary traits
# time Rscript saige_step1_quant.R -s sim1_h08 -a all -f 1G_3000n_100causal_500000m -n $input_value
# time Rscript saige_step2_quant.R -s sim1_h08 -a all -f 1G_3000n_100causal_500000m -n $input_value
# 
# time Rscript saige_step1_quant.R -s sim1_h08 -a sex -f 1G_3000n_100causal_500000m_male -n $input_value
# time Rscript saige_step2_quant.R -s sim1_h08 -a sex -f 1G_3000n_100causal_500000m_male -n $input_value
# 
# time Rscript saige_step1_quant.R -s sim1_h08 -a sex -f 1G_3000n_100causal_500000m_female -n $input_value
# time Rscript saige_step2_quant.R -s sim1_h08 -a sex -f 1G_3000n_100causal_500000m_female -n $input_value

# time Rscript saige_step1_quant.R -s sim1_h08 -a all -f 30G_3000n_100causal_500000m -n $input_value
# time Rscript saige_step2_quant.R -s sim1_h08 -a all -f 30G_3000n_100causal_500000m -n $input_value
# 
# time Rscript saige_step1_quant.R -s sim1_h08 -a sex -f 30G_3000n_100causal_500000m_male -n $input_value
# time Rscript saige_step2_quant.R -s sim1_h08 -a sex -f 30G_3000n_100causal_500000m_male -n $input_value
# 
# time Rscript saige_step1_quant.R -s sim1_h08 -a sex -f 30G_3000n_100causal_500000m_female -n $input_value
# time Rscript saige_step2_quant.R -s sim1_h08 -a sex -f 30G_3000n_100causal_500000m_female -n $input_value

# time Rscript saige_step1_quant.R -s sim3_h08 -a all -f 30G_3000n_100causal_500000m -n $input_value
# time Rscript saige_step2_quant.R -s sim3_h08 -a all -f 30G_3000n_100causal_500000m -n $input_value
# 
# time Rscript saige_step1_quant.R -s sim3_h08 -a sex -f 30G_3000n_100causal_500000m_male -n $input_value
# time Rscript saige_step2_quant.R -s sim3_h08 -a sex -f 30G_3000n_100causal_500000m_male -n $input_value
# 
# time Rscript saige_step1_quant.R -s sim3_h08 -a sex -f 30G_3000n_100causal_500000m_female -n $input_value
# time Rscript saige_step2_quant.R -s sim3_h08 -a sex -f 30G_3000n_100causal_500000m_female -n $input_value

# 
time Rscript saige_step1_quant.R -s sim4_h08 -a all -f 30G_3000n_100causal_500000m -n $input_value
time Rscript saige_step2_quant.R -s sim4_h08 -a all -f 30G_3000n_100causal_500000m -n $input_value

# time Rscript saige_step1_quant.R -s sim4_h08 -a sex -f 30G_3000n_100causal_500000m_male -n $input_value
# time Rscript saige_step2_quant.R -s sim4_h08 -a sex -f 30G_3000n_100causal_500000m_male -n $input_value
# 
# time Rscript saige_step1_quant.R -s sim4_h08 -a sex -f 30G_3000n_100causal_500000m_female -n $input_value
# time Rscript saige_step2_quant.R -s sim4_h08 -a sex -f 30G_3000n_100causal_500000m_female -n $input_value


module unload R/4.1.1-rhel8
