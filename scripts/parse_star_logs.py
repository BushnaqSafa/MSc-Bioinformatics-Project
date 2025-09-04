import os
import pandas as pd

log_dir = "/user/work/no24141/RNAseq_Project/results/star/chm13"
samples = []
input_reads = []
unique_reads = []
multi_reads = []
unmapped_tooshort = []


for log_file in os.listdir(log_dir):
    if log_file.endswith("Log.final.out"):
        with open(os.path.join(log_dir, log_file)) as f:
            lines = f.readlines()
            sample = log_file.split("_")[0]
            samples.append(sample)
            input_reads.append(int(lines[5].split('|')[1].strip()))
            unique_reads.append(int(lines[8].split('|')[1].strip()))
            multi_reads.append(int(lines[23].split('|')[1].strip()))
            unmapped_tooshort.append(int(lines[30].split('|')[1].strip().replace('%','')))

df = pd.DataFrame({
    "Sample": samples,
    "Input Reads": input_reads,
    "Uniquely Mapped": unique_reads,
    "Multi-mapped": multi_reads,
    "Unmapped": unmapped_tooshort
})

df.to_excel("/user/work/no24141/RNAseq_Project/logs/alignment_summary_chm13.xlsx", index=False)

