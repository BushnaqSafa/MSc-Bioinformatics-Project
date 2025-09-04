#!/bin/bash
#SBATCH --job-name=star_index_hg19
#SBATCH --output=/user/work/no24141/RNAseq_Project/logs/star_index_hg19_%j.out
#SBATCH --error=/user/work/no24141/RNAseq_Project/logs/star_index_hg19_%j.err
#SBATCH --partition=test
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=12
#SBATCH --mem-per-cpu=8G
#SBATCH --account=bisc035064

# Load STAR
module load star/2.7.11b

# Define paths
GENOME_DIR=/user/work/no24141/RNAseq_Project/genomes/hg19
FASTA=$GENOME_DIR/genome.fa
GTF=$GENOME_DIR/annotation.gtf
INDEX_DIR=$GENOME_DIR/STAR_index

mkdir -p "$INDEX_DIR"

# Run STAR genome index generation
STAR --runThreadN 12 \
  --runMode genomeGenerate \
  --genomeDir "$INDEX_DIR" \
  --genomeFastaFiles "$FASTA" \
  --sjdbGTFfile "$GTF" \
  --sjdbOverhang 149 \
  --limitGenomeGenerateRAM=96000000000

echo "✅ STAR index for hg19  created successfully.


