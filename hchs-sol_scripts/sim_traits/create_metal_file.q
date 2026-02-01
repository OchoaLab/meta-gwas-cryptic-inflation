#!/bin/bash

#SBATCH --job-name=write_metal
#SBATCH --output=write-metal-%a.out
#SBATCH --account=pro00108518
#SBATCH --mem=10G
#SBATCH --array=1
#SBATCH --ntasks-per-node=10
#SBATCH --mail-user=tiffany.tu@duke.edu
#SBATCH --mail-type=END,FAIL

rep_num=$((SLURM_ARRAY_TASK_ID))
#### LOCO
# Create the output file name
#output_file="meta_sex_simtrait_loco_${rep_num}.txt"

# # Write the content to the file
# cat <<EOL > "$output_file"
# # Describe and process the input files
# MARKER   MarkerID
# WEIGHT   N 
# ALLELE   Allele1 Allele2
# FREQ     AF_Allele2
# EFFECT   BETA
# STDERR   SE
# PVAL     p.value
# 
# PROCESS /home/tt207/pro00108518/hchs-sol/Ia/cryptic-relatedness/sim_traits/rep_${rep_num}/saige_output_female_simtrait_loco_1000.txt
# 
# # Describe and process the input files
# MARKER   MarkerID
# WEIGHT   N
# ALLELE   Allele1 Allele2
# FREQ     AF_Allele2
# EFFECT   BETA
# STDERR   SE
# PVAL     p.value
# 
# PROCESS /home/tt207/pro00108518/hchs-sol/Ia/cryptic-relatedness/sim_traits/rep_${rep_num}/saige_output_male_simtrait_loco_1000.txt
# 
# # Execute meta-analysis
# OUTFILE /home/tt207/pro00108518/hchs-sol/Ia/cryptic-relatedness/sim_traits/metal/output/simtrait_loco_${rep_num}_1000. txt
# ANALYZE
# EOL
# 
# echo "Generated ${output_file}"


#### NO LOCO
# Create the output file name
output_file="meta_sex_simtrait_noloco_${rep_num}_150.txt"

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

PROCESS /home/tt207/pro00108518/hchs-sol/Ia/cryptic-relatedness/sim_traits/rep_${rep_num}/saige_output_simtrait_female_1000.txt

# Describe and process the input files
MARKER   MarkerID
WEIGHT   N
ALLELE   Allele1 Allele2
FREQ     AF_Allele2
EFFECT   BETA
STDERR   SE
PVAL     p.value

PROCESS /home/tt207/pro00108518/hchs-sol/Ia/cryptic-relatedness/sim_traits/rep_${rep_num}/saige_output_simtrait_male_1000.txt

# Execute meta-analysis
OUTFILE /home/tt207/pro00108518/hchs-sol/Ia/cryptic-relatedness/sim_traits/metal/output/simtrait_noloco_${rep_num}_1000. txt
ANALYZE
EOL

echo "Generated ${output_file}"
