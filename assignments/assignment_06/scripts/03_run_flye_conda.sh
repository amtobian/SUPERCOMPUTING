#!/bin/bash
set -ueo pipefail

# load module 
module load miniforge3

# set up conda
eval "$(conda shell.bash hook)"

# activate conda
conda activate flye-env

# make directory where things will go 
mkdir -p ./assemblies/assembly_conda

# run flye on 6 threads 
flye --nano-raw ./data/SRR33939694.fastq --out-dir ./assemblies/assembly_conda/ --threads 6

# after flye has ran move things around and remove things 
mv ./assemblies/assembly_conda/assembly.fasta ./assemblies/assembly_conda/conda_assembly.fasta 
mv ./assemblies/assembly_conda/flye.log ./assemblies/assembly_conda/conda_flye.log
rm -rf ./assemblies/assembly_conda/00-assembly
rm -rf ./assemblies/assembly_conda/10-consensus
rm -rf ./assemblies/assembly_conda/params.json

# get out of conda
conda deactivate
