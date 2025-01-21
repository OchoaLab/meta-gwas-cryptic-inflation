#!/bin/bash
#SBATCH -p ochoalab --account=ochoalab
#SBATCH --job-name=hchs-sol_saige_sex
#SBATCH --output=hchs_quant_sex.out
#SBATCH --mem=100G
#SBATCH --ntasks-per-node=24
#SBATCH --mail-user=tiffany.tu@duke.edu
#SBATCH --mail-type=END,FAIL

input_value=$((SLURM_ARRAY_TASK_ID))

export LD_LIBRARY_PATH=/opt/apps/rhel8/lapack/lib64:$LD_LIBRARY_PATH
module load R/4.1.1-rhel8

traits=("BMI" "HEIGHT" "WAIST_HIP" "INSULIN_FAST")



# Loop through the traits and trait_age arrays
for i in "${!traits[@]}"; do
trait=${traits[$i]}

# Run R scripts for male
echo "Running for male: $trait and $age_trait"
time Rscript saige_step1_quant.R -s male -t "$trait" 
time Rscript saige_step2_quant.R -s male -t "$trait" 

# Run R scripts for female
echo "Running for female: $trait and $age_trait"
time Rscript saige_step1_quant.R -s female -t "$trait" 
time Rscript saige_step2_quant.R -s female -t "$trait" 
done

module unload R/4.1.1-rhel8
