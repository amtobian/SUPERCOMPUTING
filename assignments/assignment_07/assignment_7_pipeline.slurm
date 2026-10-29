#!/bin/bash
#SBATCH --job-name=Assignment_7_Pipeline
#SBATCH --nodes=1 # how many physical machines in the cluster
#SBATCH --ntasks=1 # how many separate 'tasks' (stick to 1)
#SBATCH --cpus-per-task=20 # how many cores (bora max is 20)
#SBATCH --time=200
#SBATCH --mem=120G # how much physical memory (all by default)
#SBATCH --mail-type=FAIL,BEGIN,END # when to email you
#SBATCH --mail-user=amtobian@wm.edu # who to email
#SBATCH -o assignment_7_pipeline_%j.out #STDOUT to file (%j is jobID)
#SBATCH -e assignment_7_pipeline_%j.err #STDERR to file (%j is jobID)

module load sratools/3.2.1

bash scripts/01_download_data.sh

bash scripts/02_clean_reads.sh

bash scripts/03_map_reads.sh

echo "Analysis Complete!"
