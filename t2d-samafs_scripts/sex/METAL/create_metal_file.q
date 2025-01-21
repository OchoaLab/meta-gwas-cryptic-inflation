#!/bin/bash
#SBATCH -p ochoalab --account=ochoalab
#SBATCH --job-name=metal_file
#SBATCH --output=meta_file.out
#SBATCH --mem=100G
#SBATCH --ntasks-per-node=10
#SBATCH --mail-user=tiffany.tu@duke.edu
#SBATCH --mail-type=END,FAIL

# Define the traits array
#traits=("sbp" "fast_ins" "a2h_glu" "a2h_ins" "creatinine" "adiponectin" "leptin" "chol" "ldl" "hdl" "tg" "bmi" "hipc" "waistc" "whr" "dbp")
traits=("cystatin_c" "whr" "weight")

# Loop through the traits array
for trait in "${traits[@]}"; do
# Create the output file name
output_file="meta_sex_${trait}.txt"

# Write the content to the file
cat <<EOL > "$output_file"
# Describe and process the input files
MARKER   MarkerID
WEIGHT   N 
ALLELE   Allele1 Allele2
FREQ     AF_Allele2
EFFECT   BETA
STDERR   SE
PVAL     p.value

PROCESS /hpc/group/ochoalab/tt207/meta_analysis_aim/samafs/saige/sex/saige_output_${trait}_female_trait_age.txt

# Describe and process the input files
MARKER   MarkerID
WEIGHT   N
ALLELE   Allele1 Allele2
FREQ     AF_Allele2
EFFECT   BETA
STDERR   SE
PVAL     p.value

PROCESS /hpc/group/ochoalab/tt207/meta_analysis_aim/samafs/saige/sex/saige_output_${trait}_male_trait_age.txt

# Execute meta-analysis
OUTFILE output_metal_sex_${trait}_trait_age .txt
ANALYZE
EOL

echo "Generated ${output_file}"
done