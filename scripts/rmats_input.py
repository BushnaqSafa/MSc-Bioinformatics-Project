
import pandas as pd
import os

# Set variables
build_name = "GRCH38" #change for other builds
bam_dir = "/user/work/no24141/RNAseq_Project/results/star/GRCH38_2_twopass"
metadata_file = "/user/work/no24141/RNAseq_Project/metadata/Metadata.csv"
output_dir = f"/user/work/no24141/RNAseq_Project/rMATS_input_{build_name}_tumor_vs_normal"  # Save b1.txt and b2.txt here

# ✅ Create output directory if it doesn't exist
os.makedirs(output_dir, exist_ok=True)

# Load metadata
df = pd.read_csv(metadata_file)

# Build full BAM paths
df['bam_path'] = df['Run'].apply(lambda run: os.path.join(bam_dir, f"{run}_Aligned.sortedByCoord.out.bam"))

# Separate by tissue type
group1_bams = df[df['tissue'] == 'breast tumor']['bam_path'].tolist()       # Group 1 = tumor
group2_bams = df[df['tissue'] == 'normal breast tissue']['bam_path'].tolist()  # Group 2 = normal

# Write comma-separated BAM paths (single line) to b1.txt and b2.txt
with open(os.path.join(output_dir, "b1.txt"), "w") as f1:
    f1.write(','.join(group1_bams) + '\n')

with open(os.path.join(output_dir, "b2.txt"), "w") as f2:
    f2.write(','.join(group2_bams) + '\n')

print("✅ Saved b1.txt and b2.txt in correct rMATS format.")

