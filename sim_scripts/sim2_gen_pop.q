#!/bin/bash
#SBATCH -p ochoalab --account=ochoalab
#SBATCH --job-name=sim2
#SBATCH --output=sim2_%a.out
#SBATCH --array=2-20
#SBATCH --mem=140G
#SBATCH --ntasks-per-node=60
#SBATCH --mail-user=tiffany.tu@duke.edu
#SBATCH --mail-type=END,FAIL

input_value=$((SLURM_ARRAY_TASK_ID))
module load R/4.1.1-rhel8
time Rscript sim2_step1.R -n $input_value
echo "finished step1"
time Rscript sim2_step2.R -n $input_value
echo "finished step2"

# merge subpop files into one plink file
module load Plink/1.90
plink --bfile ./sim2_h08/rep$input_value/subpop/30G_3000n_100causal_500000m_S1 --bmerge ./sim2_h08/rep$input_value/subpop/30G_3000n_100causal_500000m_S2 --make-bed --out ./sim2_h08/rep$input_value/merged_temp
plink --bfile ./sim2_h08/rep$input_value/merged_temp --bmerge ./sim2_h08/rep$input_value/subpop/30G_3000n_100causal_500000m_S3 --make-bed --out ./sim2_h08/rep$input_value/30G_3000n_100causal_500000m
module unload Plink/1.90

rm ./sim2_h08/rep$input_value/merged_temp*
# #   
time Rscript sim2_step3.R -n $input_value
echo "finished step3"
module unload R/4.1.1-rhel8
