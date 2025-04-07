#!/bin/bash
#SBATCH -p ochoalab --account=ochoalab
#SBATCH --job-name=metal_file_trait
#SBATCH --output=meta_file_trait.out
#SBATCH --mem=100G
#SBATCH --ntasks-per-node=10
#SBATCH --mail-user=tiffany.tu@duke.edu
#SBATCH --mail-type=END,FAIL

# Define the traits array
#traits=("LOG_LABA68" "LOG_LABA69" "LOG_ANTA4" "LOG_LABA66" "LOG_BMI" "LOG_ANTA10A" "LOG_ANTA10B" "LOG_SBPA5" "LOG_SBPA6" "LOG_INSULIN_FAST" "HEIGHT" "WAIST_HIP" "LOG_LABA70" "LOG_LABA76" "LOG_LABA67" "LOG_LABA101" "LOG_LABA91" "LABA66")


#traits=("LOG_WAIST_HIP" "LOG_INSULIN_OGTT" "LOG_LABA1" "LABA10" "LABA11" "LABA12" "LABA13" "LABA14" "LABA2" "LOG_LABA3" "LOG_LABA9" "LOG_LABA74" "LOG_LABA75" "LOG_LABA102" "LOG_LABA103" "LOG_LABA82" "LOG_SLPA54")
#traits=("LABA2" "LOG_LABA75" "LOG_SLPA54")
traits="LOG_WAIST_HIP"

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

PROCESS /hpc/dctrl/tt207/meta_analysis_aim/hchs-sol/saige/saige_output_${trait}_female.txt

# Describe and process the input files
MARKER   MarkerID
WEIGHT   N
ALLELE   Allele1 Allele2
FREQ     AF_Allele2
EFFECT   BETA
STDERR   SE
PVAL     p.value

PROCESS /hpc/dctrl/tt207/meta_analysis_aim/hchs-sol/saige/saige_output_${trait}_male.txt

# Execute meta-analysis
OUTFILE output_metal_sex_${trait}_trait .txt
ANALYZE
EOL

echo "Generated ${output_file}"
done