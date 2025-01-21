#!/bin/bash
#SBATCH -p ochoalab --account=ochoalab
#SBATCH --job-name=ssns.write
#SBATCH --output=write_ssns.out
#SBATCH --mem=140G
#SBATCH --ntasks-per-node=60
#SBATCH --mail-user=tiffany.tu@duke.edu
#SBATCH --mail-type=END,FAIL

conda activate RSAIGE
time Rscript write_N_weight.R 