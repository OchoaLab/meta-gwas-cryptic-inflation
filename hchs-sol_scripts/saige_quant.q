#!/bin/bash
#SBATCH -p ochoalab --account=ochoalab
#SBATCH --job-name=hchs-sol-saige-trait4
#SBATCH --output=hchs-sol-saige-trait4.out
#SBATCH --mem=100G
#SBATCH --ntasks-per-node=24
#SBATCH --mail-user=tiffany.tu@duke.edu
#SBATCH --mail-type=END,FAIL


export LD_LIBRARY_PATH=/opt/apps/rhel8/lapack/lib64:$LD_LIBRARY_PATH
module load R/4.1.1-rhel8


#traits=("BMI" "HEIGHT" "WAIST_HIP" "INSULIN_FAST")
#traits=("LOG_INSULIN_FAST" "LOG_LABA70" "LOG_LABA76" "LOG_LABA101" "LOG_LABA91" "LABA66")
#traits=("LOG_LABA67" "LABA68" "LABA69" "ANTA4")
traits=("ANTA10A" "ANTA10B" "SBPA5" "SBPA6")
# Loop through the traits and trait_age arrays
for i in "${!traits[@]}"; do
trait=${traits[$i]}

# Run R scripts
echo "Running joint gwas: $trait"
time Rscript saige_step1_quant.R -t "$trait" 
time Rscript saige_step2_quant.R -t "$trait"

done

module unload R/4.1.1-rhel8
