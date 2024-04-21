#!/bin/bash
#SBATCH -p ochoalab --account=ochoalab
#SBATCH --job-name=combine
#SBATCH --output=combine_group.out
#SBATCH --mem=160G
#SBATCH --ntasks-per-node=60
#SBATCH --mail-user=tiffany.tu@duke.edu
#SBATCH --mail-type=END,FAIL

output_file="combined_eval_tables_study.txt"

# Append the header from the first file
head -n 1 eval_tables_group_1.txt > "$output_file"

# Append the content from the rest of the files without the header
for ((i=1; i<=50; i++)); do
    if [ -f "eval_tables_group_$i.txt" ]; then
        tail -n +2 eval_tables_group_"$i".txt >> "$output_file"
    else
        echo "File eval_tables_group_$i.txt does not exist. Skipping..."
    fi
done

echo "Files combined successfully into $output_file"