import pandas as pd

# Path to metadata file
metadata_path = "/user/work/no24141/RNAseq_Project/metadata/Metadata.csv"

# Load metadata
meta_df = pd.read_csv(metadata_path, dtype=str)

# Keep only relevant columns (adjust as needed)
meta_df = meta_df[["Run", "Donor", "tissue", "metastasis"]]

# Add a new column for the STAR ReadsPerGene output file
meta_df["file"] = meta_df["Run"] + "_CHM13_ReadsPerGene.out.tab"

# Reorder columns for clarity
meta_df = meta_df[["Donor", "file", "tissue", "metastasis"]]

# Save updated metadata table
output_path = "/user/work/no24141/RNAseq_Project/metadata/sample_metadata_CHM13.csv"
meta_df.to_csv(output_path, index=False)

print(f"✅ Sample metadata with file names saved to {output_path}")

