#!/bin/bash
#SBATCH --job-name=extract_coords
#SBATCH --output=/user/work/no24141/RNAseq_Project/logs/chm13_coords_%j.out
#SBATCH --error=/user/work/no24141/RNAseq_Project/logs/chm13_coords_%j.err
#SBATCH --partition=short
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --mem=2G
#SBATCH --time=00:10:00
#SBATCH --account=bisc035064


# Define paths
GFF_FILE="/user/work/no24141/RNAseq_Project/genomes/CHM13/annotation.gff3"
OUT_FILE="/user/work/no24141/RNAseq_Project/results/coordinates/chm13_gene_coords.txt"

# Extract gene coordinates
awk '$3 == "gene" { 
    match($0, /ID=([^;]+)/, a);
    match($0, /Name=([^;]+)/, b);
    if (a[1] != "" && b[1] != "") print $1, $4, $5, b[1];
}' "$GFF_FILE" > "$OUT_FILE"

echo "Gene coordinate extraction complete. Output: $OUT_FILE"

