#!/bin/bash
#SBATCH -p ochoalab --account=ochoalab
#SBATCH --job-name=meta_srns_ssns
#SBATCH --output=meta_srns_ssns.out
#SBATCH --mem=220G
#SBATCH --ntasks-per-node=10
#SBATCH --mail-user=tiffany.tu@duke.edu
#SBATCH --mail-type=END,FAIL

# NOTE: 32G sufficed for HO and HGDP, but increased for TGP



/datacommons/ochoalab/metal/metal meta_srns_ssns.txt