#!/bin/bash
#SBATCH -p ochoalab --account=ochoalab
#SBATCH --job-name=plink_5kcausal_sim1_subpop
#SBATCH --output=plink_5kcausal_sim1_subpop_%a.out
#SBATCH --array=1-20
#SBATCH --mem=80G
#SBATCH --ntasks-per-node=12
#SBATCH --mail-user=tiffany.tu@duke.edu
#SBATCH --mail-type=END,FAIL

# plink2 --glm for sim1 subpop, 5000causal.

set -euo pipefail

rep_num=$SLURM_ARRAY_TASK_ID
base=/hpc/dctrl/tt207/meta_analysis_aim
sub_dir=${base}/sim1_h08/rep${rep_num}/subpop

module load Plink/2.00a2LM

for s in S1 S2 S3; do
  covar=${sub_dir}/covar_saige_1G_3000n_5000causal_500000m_${s}_quant.txt
  bfile=${sub_dir}/1G_3000n_5000causal_500000m_${s}
  prefix=${sub_dir}/plink_output_1G_3000n_5000causal_500000m_${s}
  plink_out=${prefix}.trait.glm.linear

  # write_covar_5kcausal.q must have already produced these)
  if [ ! -d "$sub_dir" ]; then
    echo "rep${rep_num}: $sub_dir does not exist — skipping; rerun sim1_5000causal.q first" >&2
    continue
  fi
  if [ ! -f "$covar" ] || [ ! -f "${bfile}.bed" ]; then
    echo "rep${rep_num} $s: missing covar or bed; run write_covar_5kcausal.q + sim1_5000causal.q first" >&2
    continue
  fi

  # rename famid/id headers to FID/IID 
  awk 'NR==1 {gsub(/famid/, "FID"); gsub(/id/, "IID")} 1' OFS="\t" "$covar" \
    > "$covar.tmp" && mv "$covar.tmp" "$covar"

  time plink2 --bfile "$bfile" \
    --glm hide-covar omit-ref \
    --pheno "$covar" \
    --pheno-name trait \
    --covar "$covar" \
    --covar-name sex-PCs.10 \
    --out "$prefix"

  header="CHROM\tPOS\tID\tREF\tALT\tA1\tTEST\tOBS_CT\tBETA\tSE\tT_STAT\tP"
  { echo -e "$header"; cat "$plink_out"; } > "${plink_out}.ADD"

  head "${plink_out}.ADD"
  rm "$plink_out"
done

module unload Plink/2.00a2LM
