#!/bin/bash
set -ueo pipefail

#make directory
mkdir -p ./assemblies/assembly_local

python ~/programs/Flye/bin/flye --nano-raw ./data/SRR33939694.fastq --out-dir ./assemblies/assembly_local/ --threads 6

mv ./assemblies/assembly_local/assembly.fasta ./assemblies/assembly_local/local_assembly.fasta 
mv ./assemblies/assembly_local/flye.log ./assemblies/assembly_local/local_flye.log
rm -rf ./assemblies/assembly_local/00-assembly
rm -rf ./assemblies/assembly_local/10-consensus
rm -rf ./assemblies/assembly_local/params.json
