#!/bin/bash
#SBATCH -p ochoalab --account=ochoalab
#SBATCH --job-name=meta_sex
#SBATCH --output=meta_sex_%a.out
#SBATCH --array=1-50
#SBATCH --mem=220G
#SBATCH --ntasks-per-node=10
#SBATCH --mail-user=tiffany.tu@duke.edu
#SBATCH --mail-type=END,FAIL

# NOTE: 32G sufficed for HO and HGDP, but increased for TGP

#time /datacommons/ochoalab/metal/metal meta_sim1_subpop.txt
input_value=$((SLURM_ARRAY_TASK_ID))

dir='/hpc/group/ochoalab/tgp-nygc-autosomes_ld_prune_1000kb_0.3_maf-0.01/rep-'$input_value'/'
file='saige_output_'

./run_metal_sex.sh "${dir}${file}male.txt" "${dir}${file}female.txt" output/output_sex
