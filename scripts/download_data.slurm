#!/bin/bash
#SBATCH --job-name=sra_download
#SBATCH --output=/user/work/no24141/RNAseq_Project/logs/sra_download_%j.out
#SBATCH --error=/user/work/no24141/RNAseq_Project/logs/sra_download_%j.err
#SBATCH --partition=short
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=2
#SBATCH --mem=12G
#SBATCH --account=bisc035064

# Load the required module
module load sra-tools/3.0.3


#input list and output directory
LIST= /user/work/no24141/RNAseq_Project/metadata/Acc_list_data3.txt
OUTDIR= /user/work/no24141/RNAseq_Project/raw_data/compressed_data3


# Loop through each SRR ID in your list and compress 
while read srr; do
    echo "Downloading $srr..."
    prefetch "$srr"
    fasterq-dump "$srr" --split-files --outdir "$OUTDIR"

    echo "Compressing FASTQ files for $srr..."
    gzip "$OUTDIR/${srr}_1.fastq" "$OUTDIR/${srr}_2.fastq"
  
    echo "$srr complete."
done < "$LIST"
echo " All SRR downloads and compression complete."
