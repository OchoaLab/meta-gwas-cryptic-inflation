#!/bin/bash
#SBATCH -p ochoalab --account=ochoalab
#SBATCH --job-name=pcs
#SBATCH --output=pcs.out
#SBATCH --mem=80G
#SBATCH --ntasks-per-node=1
#SBATCH --mail-user=tiffany.tu@duke.edu
#SBATCH --mail-type=END,FAIL

# NOTE: 32G sufficed for HO and HGDP, but increased for TGP


# create PCs from grm 
time gcta --grm /hpc/group/ochoalab/zh105/project2/hchs-sol/Ia/data_qc_std_mor --pca 10 --out data_qc_std_mor