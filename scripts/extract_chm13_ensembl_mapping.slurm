#!/bin/bash
#SBATCH --job-name=chm13_extract
#SBATCH --output=chm13_extract_%j.out
#SBATCH --error=chm13_extract_%j.err
#SBATCH --time=00:10:00
#SBATCH --partition=test
#SBATCH --mem=2G

module load languages/python/3.8.20


# chm13_gff_to_ensembl_map.py

gff_file = "/user/work/no24141/RNAseq_Project/genomes/CHM13/chm13.draft_v2.0.gene_annotation.gff3"
output_file = "chm13_to_ensembl_mapping.txt"


with open(gff_file, "r") as infile, open(output_file, "w") as outfile:
    outfile.write("CHM13_GeneID\tEnsemblID\n")
    
    for line in infile:
        if line.startswith("#"):
            continue
        fields = line.strip().split("\t")
        if fields[2] != "gene":
            continue
        attributes = fields[8]
        
        chm13_gene_id = None
        ensembl_id = None
        
        for attr in attributes.split(";"):
            if attr.startswith("gene_id="):
                chm13_gene_id = attr.split("=")[1]
            if attr.startswith("source_gene="):
                ensembl_id = attr.split("=")[1]
        
        if chm13_gene_id and ensembl_id and ensembl_id != "N/A":
            outfile.write(f"{chm13_gene_id}\t{ensembl_id}\n")


