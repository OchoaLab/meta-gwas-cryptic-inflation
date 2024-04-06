#!/bin/bash
#SBATCH -p ochoalab --account=ochoalab
#SBATCH --job-name=meta_sim1_subpop
#SBATCH --output=meta_sim1_subpop_%a.out
#SBATCH --array=1-10
#SBATCH --mem=220G
#SBATCH --ntasks-per-node=10
#SBATCH --mail-user=tiffany.tu@duke.edu
#SBATCH --mail-type=END,FAIL

# NOTE: 32G sufficed for HO and HGDP, but increased for TGP

#time /datacommons/ochoalab/metal/metal meta_sim1_subpop.txt
input_value=$((SLURM_ARRAY_TASK_ID))

dir='/datacommons/ochoalab/tiffany_data/meta_analysis_aim/sim1/rep'$input_value'/subpop/'
file='saige_output_1G_3000n_100causal_500000m_'

./run_metal_subpop.sh "${dir}${file}S1.txt" "${dir}${file}S2.txt" "${dir}${file}S3.txt" sim1/output_subpop
