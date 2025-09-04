
import os

directory = "/user/work/no24141/RNAseq_Project/results/star/chm13"
build = "CHM13"

for filename in os.listdir(directory):
    if filename.endswith("ReadsPerGene.out.tab") and build not in filename:
        new_name = filename.replace("ReadsPerGene.out.tab", f"{build}_ReadsPerGene.out.tab")
        os.rename(os.path.join(directory, filename), os.path.join(directory, new_name))

