#!/bin/bash
#SBATCH --job-name=gene_map_mixed
#SBATCH --output=gene_map_mixed_%j.out
#SBATCH --error=gene_map_mixed_%j.err
#SBATCH --time=01:00:00
#SBATCH --mem=2G
#SBATCH --cpus-per-task=1
#SBATCH --partition=test


# hg19 GTF 
awk '$3 == "gene" { 
    match($0, /gene_id "([^"]+)"/, a);
    match($0, /gene_name "([^"]+)"/, b);
    if (a[1] != "" && b[1] != "") print a[1], b[1];
}' /user/work/no24141/RNAseq_Project/genomes/hg19/annotation.gtf > hg19_gene_map.txt

# GRCh38 GTF
awk '$3 == "gene" { 
    match($0, /gene_id "([^"]+)"/, a);
    match($0, /gene_name "([^"]+)"/, b);
    if (a[1] != "" && b[1] != "") print a[1], b[1];
}' /user/work/no24141/RNAseq_Project/genomes/GRCH38/annotation.gtf > grch38_gene_map.txt

# CHM13 GFF3 (adapted for key=value format)
awk '$3 == "gene" {
    match($9, /ID=([^;]+)/, id);
    match($9, /Name=([^;]+)/, name);
    if (id[1] != "" && name[1] != "") print id[1], name[1];
}' /user/work/no24141/RNAseq_Project/genomes/CHM13/annotation.gff3 > chm13_gene_map.txt

