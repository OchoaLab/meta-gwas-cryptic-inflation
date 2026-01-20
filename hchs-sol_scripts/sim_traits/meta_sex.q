#!/bin/bash

#SBATCH --job-name=hchs_metal
#SBATCH --output=metal-%a-150.out
#SBATCH --account=pro00108518
#SBATCH --mem=60G
#SBATCH --array=1
#SBATCH --ntasks-per-node=10
#SBATCH --mail-user=tiffany.tu@duke.edu
#SBATCH --mail-type=END,FAIL

# NOTE: 32G sufficed for HO and HGDP, but increased for TGP

rep_num=$((SLURM_ARRAY_TASK_ID))
# #### LOCO
# # Set the meta file name for the current trait
# meta_file="meta_sex_simtrait_loco_${rep_num}.txt"
# 
# # Run the METAL command with the current meta file
# echo "Running METAL for ${meta_file}"
# /home/tt207/pro00108518/metal/metal "$meta_file"
# 
# # Optional: Check the exit status of the METAL command
# if [ $? -ne 0 ]; then
# echo "Error: METAL failed for ${trait}"
# exit 1
# fi

#### NO LOCO
# Set the meta file name for the current trait
meta_file="meta_sex_simtrait_noloco_${rep_num}_150.txt"

# Run the METAL command with the current meta file
echo "Running METAL for ${meta_file}"
/home/tt207/pro00108518/metal/metal "$meta_file"

# Optional: Check the exit status of the METAL command
if [ $? -ne 0 ]; then
echo "Error: METAL failed for ${trait}"
exit 1
fi