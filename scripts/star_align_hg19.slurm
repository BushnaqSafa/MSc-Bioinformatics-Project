#!/bin/bash
#SBATCH --job-name=align_hg19
#SBATCH --output=/user/work/no24141/RNAseq_Project/logs/star_align_hg19_2_%j.out
#SBATCH --error=/user/work/no24141/RNAseq_Project/logs/star_align_hg19_2_%j.err
#SBATCH --partition=short
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=12
#SBATCH --mem-per-cpu=8G
#SBATCH --account=bisc035064

# Load STAR
module load star/2.7.11b

# Define paths
IN_DIR=/user/work/no24141/RNAseq_Project/results/fastp_new
OUT_DIR=/user/work/no24141/RNAseq_Project/results/star/hg19_2
INDEX_DIR=/user/work/no24141/RNAseq_Project/genomes/hg19/STAR_index

mkdir -p "$OUT_DIR"

# Loop through cleaned FASTQ files
for R1 in ${IN_DIR}/*_1.clean.fastq.gz; do
    SAMPLE=$(basename "$R1" _1.clean.fastq.gz)
    R2=${IN_DIR}/${SAMPLE}_2.clean.fastq.gz

    echo "Aligning $SAMPLE..."

    STAR --runThreadN 12 \
        --genomeDir "$INDEX_DIR" \
        --readFilesIn "$R1" "$R2" \
        --readFilesCommand zcat \
        --outFileNamePrefix "$OUT_DIR/${SAMPLE}_" \
        --outSAMtype BAM SortedByCoordinate \
        --outSAMunmapped Within \
        --quantMode GeneCounts

    echo "$SAMPLE alignment complete."
done

echo "✅ All alignments to hg19 completed."

