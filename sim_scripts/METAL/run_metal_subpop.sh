#!/bin/bash

# Check if both input file names and output prefix are provided
if [ $# -ne 4 ]; then
    echo "Usage: $0 <input_file_1> <input_file_2> <input_file_3> <output_prefix>"
    exit 1
fi

# Replace placeholder variables with actual file names and output prefix
sed -e "s|INPUT_PLACEHOLDER_1.txt|$1|g" \
    -e "s|INPUT_PLACEHOLDER_2.txt|$2|g" \
    -e "s|INPUT_PLACEHOLDER_3.txt|$3|g" \
    -e "s|OUTPUT_PLACEHOLDER|$4_${SLURM_ARRAY_TASK_ID}|g" meta_subpop_temp.txt > meta_subpop_${SLURM_ARRAY_TASK_ID}.txt

# Run METAL with the modified script
/datacommons/ochoalab/metal/metal meta_subpop_${SLURM_ARRAY_TASK_ID}.txt