#!/bin/bash
#SBATCH -p biostat --account=biostat 
#SBATCH --job-name=sim4
#SBATCH --array=1-5
#SBATCH --output=sim4_%a.out
#SBATCH --mem=180G
#SBATCH --ntasks-per-node=60
#SBATCH --mail-user=tiffany.tu@duke.edu
#SBATCH --mail-type=END,FAIL

input_value=$((SLURM_ARRAY_TASK_ID))

root=/hpc/group/ochoalab/tt207/meta_analysis_aim
base_dir=${root}/sim4_10000/rep${input_value}
base_file=${base_dir}/30G_10000n_100causal_500000m
module load R/4.1.1-rhel8
# 1. R preprocessing: write keep_n8000.txt and keep_n6000.txt into base_dir
Rscript subset_plink.R ${input_value}
module unload R/4.1.1-rhel8

module load Plink/1.90
# 2. Run plink for each subset size, writing to sim4_${n}/rep${input_value}
for n in 4000 2000; do
    out_dir=${root}/sim4_${n}/rep${input_value}
    mkdir -p ${out_dir}
    plink --bfile ${base_file} \
          --keep ${base_dir}/keep_n${n}.txt \
          --make-bed \
          --out ${out_dir}/30G_${n}n_100causal_500000m
done
module unload Plink/1.90