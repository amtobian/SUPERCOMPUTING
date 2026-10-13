#!/bin/bash
set -ueo pipefail


# create folders 
mkdir -p assemblies/assembly_conda assemblies/assembly_local assemblies/assembly_module data scripts

# get the data
wget https://zenodo.org/records/15730819/files/SRR33939694.fastq.gz

# move the data to the correct file 
mv SRR33939694.fastq.gz ~/SUPERCOMPUTING/assignments/assignment_06/data

