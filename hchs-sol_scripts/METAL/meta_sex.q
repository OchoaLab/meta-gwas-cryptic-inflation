#!/bin/bash
#SBATCH -p ochoalab --account=ochoalab
#SBATCH --job-name=hchs_sex_trait
#SBATCH --output=hchs_sex_trait.out
#SBATCH --mem=220G
#SBATCH --ntasks-per-node=10
#SBATCH --mail-user=tiffany.tu@duke.edu
#SBATCH --mail-type=END,FAIL

# NOTE: 32G sufficed for HO and HGDP, but increased for TGP


# Define the traits array
#traits=("LOG_LABA68" "LOG_LABA69" "LOG_ANTA4" "LOG_LABA66" "LOG_BMI" "LOG_ANTA10A" "LOG_ANTA10B" "LOG_SBPA5" "LOG_SBPA6" "LOG_INSULIN_FAST" "HEIGHT" "WAIST_HIP" "LOG_LABA70" "LOG_LABA76" "LOG_LABA67" "LOG_LABA101" "LOG_LABA91" "LABA66")
#traits=("LOG_WAIST_HIP" "LOG_INSULIN_OGTT" "LOG_LABA1" "LABA10" "LABA11" "LABA12" "LABA13" "LABA14" "LABA2" "LOG_LABA3" "LOG_LABA9" "LOG_LABA74" "LOG_LABA75" "LOG_LABA102" "LOG_LABA103" "LOG_LABA82" "LOG_SLPA54")
#traits=("LABA2" "LOG_LABA75" "LOG_SLPA54")
traits=("LOG_WAIST_HIP")

# Loop through the traits array
for trait in "${traits[@]}"; do
# Set the meta file name for the current trait
meta_file="meta_sex_${trait}.txt"

# Run the METAL command with the current meta file
echo "Running METAL for ${meta_file}"
/hpc/dctrl/tt207/meta_analysis_aim/METAL/metal/metal "$meta_file"

# Optional: Check the exit status of the METAL command
if [ $? -ne 0 ]; then
echo "Error: METAL failed for ${trait}"
exit 1
fi
done
