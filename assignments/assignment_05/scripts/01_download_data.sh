#!/bin/bash
set -ueo pipefail

# 01 Download Data Script Allie Tobian 

#Downloads the data file
wget https://gzahn.github.io/data/fastq_examples.tar


#Puts all the fastq files into ./data/raw/
mv fastq_examples.tar ~/SUPERCOMPUTING/assignments/assignment_05/data/raw

cd ~/SUPERCOMPUTING/assignments/assignment_05/data/raw

#Extracts the contents
tar -xf fastq_examples.tar

#Cleans up the `fastq_examples.tar` file
rm fastq_examples.tar
