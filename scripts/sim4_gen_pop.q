#!/bin/bash
#SBATCH -p ochoalab --account=ochoalab
#SBATCH --job-name=sim4
#SBATCH --array=3-4
#SBATCH --output=sim4_%a.out
#SBATCH --mem=120G
#SBATCH --ntasks-per-node=60
#SBATCH --mail-user=tiffany.tu@duke.edu
#SBATCH --mail-type=END,FAIL

input_value=$((SLURM_ARRAY_TASK_ID))

module load R/4.1.1-rhel8
time Rscript sim4_step1.R -n $input_value
echo "finished step1"
time Rscript sim4_step2.R -n $input_value
echo "finished step2"
time Rscript sim4_step3.R -n $input_value
echo "finished step3"
time Rscript sim4_step4.R -n $input_value
echo "finished step4"
module unload R/4.1.1-rhel8

# # split by subpop and sex
#module load Plink/1.90
# # time plink --keep-allele-order --bfile /datacommons/ochoalab/tiffany_data/meta_analysis_aim/sim4/30G_3000n_100causal_500000m --keep-fam S1.txt --make-bed --out /datacommons/ochoalab/tiffany_data/meta_analysis_aim/sim3/subpop/3000n_100causal_500000m_S1
# # time plink --keep-allele-order --bfile /datacommons/ochoalab/tiffany_data/meta_analysis_aim/sim4/30G_3000n_100causal_500000m --keep-fam S2.txt --make-bed --out /datacommons/ochoalab/tiffany_data/meta_analysis_aim/sim3/subpop/3000n_100causal_500000m_S2
# # time plink --keep-allele-order --bfile /datacommons/ochoalab/tiffany_data/meta_analysis_aim/sim4/30G_3000n_100causal_500000m --keep-fam S3.txt --make-bed --out /datacommons/ochoalab/tiffany_data/meta_analysis_aim/sim3/subpop/3000n_100causal_500000m_S3
# 
# time plink --keep-allele-order --bfile /datacommons/ochoalab/tiffany_data/meta_analysis_aim/sim4/30G_3000n_100causal_500000m --filter-males --make-bed --out /datacommons/ochoalab/tiffany_data/meta_analysis_aim/sim4/sex/30G_3000n_100causal_500000m_males
# time plink --keep-allele-order --bfile /datacommons/ochoalab/tiffany_data/meta_analysis_aim/sim4/30G_3000n_100causal_500000m --filter-females --make-bed --out /datacommons/ochoalab/tiffany_data/meta_analysis_aim/sim4/sex/30G_3000n_100causal_500000m_females
# # # 
# # # # grm
# # # #
# time gcta --bfile /datacommons/ochoalab/tiffany_data/meta_analysis_aim/sim4/30G_3000n_100causal_500000m --make-grm --out /datacommons/ochoalab/tiffany_data/meta_analysis_aim/sim4/30G_3000n_100causal_500000m
# time gcta --grm /datacommons/ochoalab/tiffany_data/meta_analysis_aim/sim4/30G_3000n_100causal_500000m --pca 10 --out /datacommons/ochoalab/tiffany_data/meta_analysis_aim/sim4/30G_3000n_100causal_500000m
# #
# time gcta --bfile /datacommons/ochoalab/tiffany_data/meta_analysis_aim/sim4/sex/30G_3000n_100causal_500000m_males --make-grm --out /datacommons/ochoalab/tiffany_data/meta_analysis_aim/sim4/sex/30G_3000n_100causal_500000m_males
# time gcta --grm /datacommons/ochoalab/tiffany_data/meta_analysis_aim/sim4/sex/30G_3000n_100causal_500000m_males --pca 10 --out /datacommons/ochoalab/tiffany_data/meta_analysis_aim/sim4/sex/30G_3000n_100causal_500000m_males
# #
# time gcta --bfile /datacommons/ochoalab/tiffany_data/meta_analysis_aim/sim4/sex/30G_3000n_100causal_500000m_females --make-grm --out /datacommons/ochoalab/tiffany_data/meta_analysis_aim/sim4/sex/30G_3000n_100causal_500000m_females
# time gcta --grm /datacommons/ochoalab/tiffany_data/meta_analysis_aim/sim4/sex/30G_3000n_100causal_500000m_females --pca 10 --out /datacommons/ochoalab/tiffany_data/meta_analysis_aim/sim4/sex/30G_3000n_100causal_500000m_females
# # 
# module unload Plink/1.90
# # # 
