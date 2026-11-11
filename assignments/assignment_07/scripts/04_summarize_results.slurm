#!/bin/bash
#SBATCH --job-name=RESULTS_SUMMARY
#SBATCH --nodes=1 # how many physical machines in the cluster
#SBATCH --ntasks=1 # how many separate 'tasks' (stick to 1)
#SBATCH --cpus-per-task=20 # how many cores (bora max is 20)
#SBATCH --time=20 
#SBATCH --mem=120G # how much physical memory (all by default)
#SBATCH --mail-type=FAIL,BEGIN,END # when to email you
#SBATCH --mail-user=amtobian@wm.edu # who to email
#SBATCH --output=/sciclone/home/amtobian/SUPERCOMPUTING/assignments/assignment_07/output/summarize_results_%j.out
#SBATCH --error=/sciclone/home/amtobian/SUPERCOMPUTING/assignments/assignment_07/output/summarize_results_%j.err

set -euo pipefail

python 04_summarize_results.py
