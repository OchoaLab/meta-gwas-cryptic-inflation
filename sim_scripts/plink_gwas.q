#!/bin/bash
#SBATCH -p ochoalab --account=ochoalab
#SBATCH --job-name=plink_gwas
#SBATCH --output=plink_gwas_sim1_rep%a.out
#SBATCH --array=2-20
#SBATCH --mem=125G
#SBATCH --ntasks-per-node=24
#SBATCH --mail-user=tiffany.tu@duke.edu
#SBATCH --mail-type=END,FAIL

# NOTE: 32G sufficed for HO and HGDP, but increased for TGP
# make directory for different pvalue thresholds:

rep_num=$((SLURM_ARRAY_TASK_ID))

module load Plink/2.00a2LM

suffixes=("S1" "S2" "S3")

for suffix in "${suffixes[@]}"; do
    # File paths
    covar_file="./sim1_h08/rep${rep_num}/subpop/covar_saige_1G_3000n_100causal_500000m_${suffix}_quant.txt"
    bfile="./sim1_h08/rep${rep_num}/subpop/1G_3000n_100causal_500000m_${suffix}"
    plink_output="./sim1_h08/rep${rep_num}/subpop/plink_output_1G_3000n_100causal_500000m_${suffix}.trait.glm.linear"
    
    # Modify header names in the covariate file
    awk 'NR==1 {gsub(/famid/, "FID"); gsub(/id/, "IID")} 1' OFS="\t" "$covar_file" > temp_${rep_num} && mv temp_${rep_num} "$covar_file"
    
    # Run PLINK
    time plink2 --bfile "$bfile" \
    --glm hide-covar omit-ref \
    --pheno "$covar_file" \
    --pheno-name trait \
    --covar "$covar_file" \
    --covar-name sex-PCs.10 \
    --out "${plink_output%.trait.glm.linear}"
    
    # Set column names and filter ADD rows
    output_file="${plink_output}.ADD"
    header="CHROM\tPOS\tID\tREF\tALT\tA1\tTEST\tOBS_CT\tBETA\tSE\tT_STAT\tP"

    {
      echo -e "$header"
      cat "$plink_output"
    } > "$output_file"

    # Print the first few lines of the output file to verify
    head "$output_file"

    # remove intermediate file
    rm ./sim1_h08/rep${rep_num}/subpop/plink_output_1G_3000n_100causal_500000m_${suffix}.trait.glm.linear
done
