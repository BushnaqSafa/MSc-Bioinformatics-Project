#!/bin/bash
#SBATCH --job-name=align_grch38
#SBATCH --output=/user/work/no24141/RNAseq_Project/logs/star_rmats_grch38_2_%j.out
#SBATCH --error=/user/work/no24141/RNAseq_Project/logs/star_rmats_grch38_2_%j.err
#SBATCH --partition=short
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=13
#SBATCH --mem-per-cpu=8G
#SBATCH --account=bisc035064

# Load STAR
module load star/2.7.11b

# Define paths
IN_DIR=/user/work/no24141/RNAseq_Project/results/fastp_new
OUT_DIR=/user/work/no24141/RNAseq_Project/results/star/GRCH38_2_twopass
INDEX_DIR=/user/work/no24141/RNAseq_Project/genomes/GRCH38/STAR_index

mkdir -p "$OUT_DIR"

# Loop through cleaned FASTQ files
for R1 in ${IN_DIR}/*_1.clean.fastq.gz; do
    SAMPLE=$(basename "$R1" _1.clean.fastq.gz)
    R2=${IN_DIR}/${SAMPLE}_2.clean.fastq.gz

    echo "Aligning $SAMPLE..."

    STAR --genomeDir "$INDEX_DIR" \
        --readFilesIn "$R1" "$R2" \
        --readFilesCommand zcat \
        --outFileNamePrefix "$OUT_DIR/${SAMPLE}_" \
        --outSAMunmapped Within \
        --outSAMattributes NH HI AS NM MD XS \
        --twopassMode Basic \
        --alignSJDBoverhangMin 1 \
        --alignSJoverhangMin 8 \
        --alignEndsType EndToEnd \
        --runThreadN 13 \
        --outSAMtype BAM SortedByCoordinate \
        --outSAMstrandField intronMotif \
        --quantMode GeneCounts

    echo "$SAMPLE alignment complete."
done


echo " ^|^e All alignments to hg19 completed."

