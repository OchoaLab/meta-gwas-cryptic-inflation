#!/bin/bash
#SBATCH -p ochoalab --account=ochoalab
#SBATCH --job-name=meta_sex_trait
#SBATCH --output=meta_sex_trait.out
#SBATCH --mem=220G
#SBATCH --ntasks-per-node=10
#SBATCH --mail-user=tiffany.tu@duke.edu
#SBATCH --mail-type=END,FAIL

# NOTE: 32G sufficed for HO and HGDP, but increased for TGP


# Define the traits array
#traits=("sbp" "fast_ins" "a2h_glu" "a2h_ins" "creatinine" "adiponectin" "leptin" "chol" "ldl" "hdl" "tg" "bmi" "hipc" "waistc" "whr" "dbp")
traits=("cystatin_c" "whr" "weight")

# Loop through the traits array
for trait in "${traits[@]}"; do
# Set the meta file name for the current trait
meta_file="meta_sex_${trait}.txt"

# Run the METAL command with the current meta file
echo "Running METAL for ${meta_file}"
/datacommons/ochoalab/metal/metal "$meta_file"

# Optional: Check the exit status of the METAL command
if [ $? -ne 0 ]; then
echo "Error: METAL failed for ${trait}"
exit 1
fi
done


# /datacommons/ochoalab/metal/metal meta_sex_height_age.txt
# /datacommons/ochoalab/metal/metal meta_sex_fast_glu_age.txt
#/datacommons/ochoalab/metal/metal meta_sex_t2d_t2d_age.txt