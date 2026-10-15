#!/bin/bash
set -ueo pipefail

# load module
module load miniforge3

# initalize conda
source "$(conda info --base)/etc/profile.d/conda.sh"

# create environment
mamba create -y -n flye-env -c conda-forge -c bioconda flye=2.9.6

# activate conda
conda activate flye-env

# test the version of conda - I installed version 2.9.6-b1802 via conda
flye -v

# export environment for reproducability
conda env export --no-builds > flye-env.yml
