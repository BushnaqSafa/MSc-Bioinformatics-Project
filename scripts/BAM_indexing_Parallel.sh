#!/bin/bash
#SBATCH --job-name=index_bam_chm13
#SBATCH --output=index_bam_chm13.out
#SBATCH --error=index_bam_chm13.err
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=16G
#SBATCH --time=02:00:00
#SBATCH --partition=compute
module load samtools

MAX_JOBS=8  # Number of parallel samtools index jobs
i=0

for bam in /user/work/no24141/RNAseq_Project/results/star/CHM13_twopass/*.bam; do
    echo "Indexing $bam"
    samtools index "$bam" &
    ((i=i+1))
    if [[ $i -ge $MAX_JOBS ]]; then
        wait
        i=0
    fi
done

# Wait for the remaining background jobs
wait


