#!/bin/bash
#SBATCH -p ochoalab --account=ochoalab
#SBATCH --job-name=meta_sim4_subpop
#SBATCH --output=meta_sim4_subpop_%a.out
#SBATCH --array=6
#SBATCH --mem=220G
#SBATCH --ntasks-per-node=10
#SBATCH --mail-user=tiffany.tu@duke.edu
#SBATCH --mail-type=END,FAIL

# NOTE: 32G sufficed for HO and HGDP, but increased for TGP

#time /datacommons/ochoalab/metal/metal meta_sim1_subpop.txt
input_value=$((SLURM_ARRAY_TASK_ID))

dir='/hpc/group/ochoalab/tt207/meta_analysis_aim/sim4_h08/rep'$input_value'/subpop/'
file='saige_output_30G_3000n_100causal_500000m_'

./run_metal_subpop.sh "${dir}${file}S1_new.txt" "${dir}${file}S2_new.txt" "${dir}${file}S3_new.txt" sim4_h08/output_subpop
