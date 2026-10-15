#!/bin/bash
set -ueo pipefail


# create folders 
mkdir -p ~/SUPERCOMPUTING/assignments/assignment_06/assemblies/assembly_conda 
mkdir -p ~/SUPERCOMPUTING/assignments/assignment_06/assemblies/assembly_local 
mkdir -p ~/SUPERCOMPUTING/assignments/assignment_06/assemblies/assembly_module
mkdir -p ~/SUPERCOMPUTING/assignments/assignment_06/data

# get the data
wget https://zenodo.org/records/15730819/files/SRR33939694.fastq.gz

# move the data to the correct file 
mv SRR33939694.fastq.gz ~/SUPERCOMPUTING/assignments/assignment_06/data

# move into the data file 
cd ~/SUPERCOMPUTING/assignments/assignment_06/data

# extract the content
gunzip SRR33939694.fastq.gz

# finish line!
echo "the data has been obtained and extracted into assignment_06/data"


