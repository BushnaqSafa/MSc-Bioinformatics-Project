import os
import pandas as pd

# === USER INPUTS ===
metadata_path = "/user/work/no24141/RNAseq_Project/metadata/Metadata.csv"
counts_dir = "/user/work/no24141/RNAseq_Project/results/star/chm13"
output_dir = "/user/work/no24141/RNAseq_Project/results/combined_counts"
os.makedirs(output_dir, exist_ok=True)

# === READ METADATA ===
metadata = pd.read_csv(metadata_path)
print("Metadata columns:", metadata.columns.tolist())

# Adjust column names to match your file exactly
sample_col = "Run" 
donor_col = "Donor"  
tissue_col = "tissue" 
metastasis_col = "metastasis"

# Create simplified sample info table
meta_df = metadata[[sample_col, donor_col, tissue_col, metastasis_col]].copy()
meta_df.columns = ['SampleID', 'Donor', 'Tissue', 'Metastasis']

# === READ STAR COUNTS ===
all_counts = []
gene_names = None

for sample in meta_df['SampleID']:
    file_path = os.path.join(counts_dir, f"{sample}_CHM13_ReadsPerGene.out.tab")
    if not os.path.exists(file_path):
        print(f"Warning: {file_path} not found, skipping.")
        continue

    df = pd.read_csv(file_path, sep='\t', header=None, comment='#')
    # Use column 0 = gene name, column 1 = unstranded
    if gene_names is None:
        gene_names = df[0].tolist()

    counts = df[1].tolist()  # Column 1 = unstranded count
    all_counts.append(pd.Series(counts, name=sample))

# === COMBINE ALL ===
count_matrix = pd.concat(all_counts, axis=1)
count_matrix.insert(0, "Gene", gene_names)
count_matrix.to_csv(f"{output_dir}/count_matrix_CHM13.csv", index=False)

# Save matching metadata
meta_df = meta_df[meta_df['SampleID'].isin(count_matrix.columns[1:])]
meta_df.to_csv(f"{output_dir}/sample_metadata_CHM13.csv", index=False)

print("✅ Count matrix and metadata table saved.")

