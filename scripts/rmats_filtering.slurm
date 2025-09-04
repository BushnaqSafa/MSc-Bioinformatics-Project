#!/bin/bash
#SBATCH --job-name=rmats_filtering
#SBATCH --output=/user/work/no24141/RNAseq_Project/logs/rmats_filter_%j.out
#SBATCH --error=/user/work/no24141/RNAseq_Project/logs/rmats_filter_%j.err
#SBATCH --partition=short
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --account=bisc035064
#SBATCH --cpus-per-task=4
#SBATCH --mem=16G

# 1) Activate conda environment
source /user/work/no24141/miniconda3/etc/profile.d/conda.sh
conda activate /user/work/no24141/RNAseq_Project/tools/rMATS_turbo/conda_envs/rmats

#directory where filtering github is cloned
GITHUB_DIR="/user/work/no24141/RNAseq_Project/tools/rMATS_turbo/rmats-turbo-tutorial/scripts"
cd "$GITHUB_DIR"

# 3) Optional: Force the conda-env Python to front of PATH  ^`^t not needed if activation works, but you can keep it just in case
export PATH=/user/work/no24141/RNAseq_Project/tools/rMATS_turbo/conda_envs/rmats/bin:$PATH

# 5) Set PYTHONPATH to where rmatspipeline module is compiled
export PYTHONPATH=$(pwd)/rMATS_pipeline:$PYTHONPATH

# Define input and output paths
INPUT_DIR="/user/work/no24141/RNAseq_Project/results/rmats_chm13/output"
BUILD_ID="chm13"  
OUTPUT_DIR="/user/work/no24141/RNAseq_Project/results/rmats_filtered/${BUILD_ID}"

# Create output directory if it doesn't exist
mkdir -p "$OUTPUT_DIR"

# Loop through all rMATS event files
for event_file in "$INPUT_DIR"/*.MATS.JC.txt; do
    echo "Processing $event_file..."
    (cd "$OUTPUT_DIR" && python "$GITHUB_DIR"/rmats_filtering.py "$event_file")
done

echo "All files processed! Output saved to $OUTPUT_DIR"


