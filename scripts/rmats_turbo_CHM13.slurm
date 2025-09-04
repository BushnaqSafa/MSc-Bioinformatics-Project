#!/bin/bash
#SBATCH --job-name=rmats_chm13
#SBATCH --output=/user/work/no24141/RNAseq_Project/logs/rmats_both_%j.out
#SBATCH --error=/user/work/no24141/RNAseq_Project/logs/rmats_both_%j.err
#SBATCH --partition=short
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --account=bisc035064
#SBATCH --cpus-per-task=48
#SBATCH --mem=96G

set -e
echo "Job started on $(hostname) at $(date)"


# Activate conda environment (correct path)
source /user/work/no24141/miniconda3/etc/profile.d/conda.sh
conda activate /user/work/no24141/RNAseq_Project/tools/rMATS_turbo/conda_envs/rmats

# Force the conda-env Python to front of PATH
export PATH=/user/work/no24141/RNAseq_Project/tools/rMATS_turbo/conda_envs/rmats/bin:$PATH

# Move into the directory where rmats.py lives
cd /user/work/no24141/RNAseq_Project/tools/rMATS_turbo/

# Set PYTHONPATH to where rmatspipeline module is compiled
export PYTHONPATH=$(pwd)/rMATS_pipeline:$PYTHONPATH

# Diagnostics
which python
python --version
echo "Installed rmats package:"
python -m pip list | grep rmats
echo "PYTHONPATH=$PYTHONPATH"
echo "Current directory: $(pwd)"
python -c "import rmatspipeline; print(' ^=^q^l rmatspipeline imported from', rmatspipeline.__file__)"

# Run rMATS
python rmats.py \
  --b1 /user/work/no24141/RNAseq_Project/rMATS_input_CHM13_tumor_vs_normal/b1.txt \
  --b2 /user/work/no24141/RNAseq_Project/rMATS_input_CHM13_tumor_vs_normal/b2.txt \
  --gtf /user/work/no24141/RNAseq_Project/genomes/CHM13/chm13_converted.gtf \
  --od /user/work/no24141/RNAseq_Project/results/rmats_chm13_novel/output \
  --tmp /user/work/no24141/RNAseq_Project/results/rmats_chm13_novel/tmp \
  --readLength 150 \
  --libType fr-unstranded \
  --nthread 48 \
  --task both \
  -t paired \
  --paired-stats \
  --anchorLength 1 \
  --variable-read-length 


echo "Job finished at $(date)"

