#!/bin/bash
#SBATCH -p ochoalab --account=ochoalab
#SBATCH --job-name=tgp_pcs
#SBATCH --output=pcs.out
#SBATCH --mem=240G
#SBATCH --ntasks-per-node=60
#SBATCH --mail-user=tiffany.tu@duke.edu
#SBATCH --mail-type=END,FAIL

module load Plink/1.90

time gcta --grm /hpc/group/ochoalab/tgp-nygc-autosomes_ld_prune_1000kb_0.3_maf-0.01/data --pca 10 --out /hpc/group/ochoalab/tgp-nygc-autosomes_ld_prune_1000kb_0.3_maf-0.01/data

module unload Plink/1.90

