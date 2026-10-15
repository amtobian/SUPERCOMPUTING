#!/bin/bash
set -ueo pipefail

module load Flye/gcc-11.4.1/2.9.6

mkdir -p ./assemblies/assembly_module

flye --nano-raw ./data/SRR33939694.fastq --out-dir ./assemblies/assembly_module/ --threads 6

mv ./assemblies/assembly_module/assembly.fasta ./assemblies/assembly_module/module_assembly.fasta 
mv ./assemblies/assembly_module/flye.log ./assemblies/assembly_module/module_flye.log
rm -rf ./assemblies/assembly_module/00-assembly
rm -rf ./assemblies/assembly_module/10-consensus
rm -rf ./assemblies/assembly_module/params.json

