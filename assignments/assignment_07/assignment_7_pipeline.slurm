#!/bin/bash
#SBATCH --job-name=Assignment_7_Pipeline
#SBATCH --nodes=1 # how many physical machines in the cluster
#SBATCH --ntasks=1 # how many separate 'tasks' (stick to 1)
#SBATCH --cpus-per-task=20 # how many cores (bora max is 20)
#SBATCH --time=2-00:00:00
#SBATCH --mem=120G # how much physical memory (all by default)
#SBATCH --mail-type=FAIL,BEGIN,END # when to email you
#SBATCH --mail-user=amtobian@wm.edu # who to email
#SBATCH --output=/sciclone/home/amtobian/SUPERCOMPUTING/assignments/assignment_07/output/assignment_7_pipeline_%j.out
#SBATCH --error=/sciclone/home/amtobian/SUPERCOMPUTING/assignments/assignment_07/output/assignment_7_pipeline_%j.err

set -euo pipefail

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$PROJECT_DIR"

export PIPELINE_DATA_DIR="/sciclone/home/amtobian/scr10/assignment_07/data"

module load sratools/3.2.1
module load miniforge3
conda activate bbmap-env
module load samtools/gcc-11.4.1/1.21

bash scripts/01_download_data.sh

bash scripts/02_clean_reads.sh

bash scripts/03_map_reads.sh

conda deactivate

echo "Analysis Complete!"
