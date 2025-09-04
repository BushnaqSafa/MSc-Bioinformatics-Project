#!/bin/bash
#SBATCH --job-name=fastp_fix
#SBATCH --output=/user/work/no24141/RNAseq_Project/logs/fastp_fix_%j.out
#SBATCH --error=/user/work/no24141/RNAseq_Project/logs/fastp_fix_%j.err
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=16G
#SBATCH --time=01:00:00
#SBATCH --partition=test
#SBATCH --account=bisc035064

module load fastp/0.23.4-c776

RAW_DIR="/user/work/no24141/RNAseq_Project/raw_data/compressed_data3"
OUT_DIR="/user/work/no24141/RNAseq_Project/results/fastp_new"
LOG_DIR="/user/work/no24141/RNAseq_Project/logs"

mkdir -p "$OUT_DIR" "$LOG_DIR"

for R1 in "$RAW_DIR"/*_1.fastq.gz; do
    SAMPLE=$(basename "$R1" _1.fastq.gz)
    R2="$RAW_DIR/${SAMPLE}_2.fastq.gz"

    echo "Processing $SAMPLE"

    fastp \
      --in1 "$R1" \
      --in2 "$R2" \
      --out1 "$OUT_DIR/${SAMPLE}_1.clean.fastq.gz" \
      --out2 "$OUT_DIR/${SAMPLE}_2.clean.fastq.gz" \
      --unpaired1 "$OUT_DIR/${SAMPLE}_1.unpaired.fastq.gz" \
      --unpaired2 "$OUT_DIR/${SAMPLE}_2.unpaired.fastq.gz" \
      --detect_adapter_for_pe \
      -w 8 \
      --html "$LOG_DIR/${SAMPLE}_fastp.html" \
      --json "$LOG_DIR/${SAMPLE}_fastp.json" \
      --cut_front --cut_tail

   echo "fastp complete for $SAMPLE"
done





