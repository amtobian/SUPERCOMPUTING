#!/bin/bash
set -ueo pipefail

# accepts the name of a fasta file as a positional argument and store as a variable
file="$1"


# calculates total number of sequences
sequences=$(seqtk comp "$file" | wc -l)

# calculautes total number of nucleotides
nucleotides=$(seqtk comp "$file" | awk '{sum +=$2} END {print sum}')

# table of sequences names and lengths
table=$(seqtk comp "$file" | cut -f 1,2)

# reports information to stdout with explanations
echo "File: $file"
echo
echo "total number of sequences: $sequences"
echo "total number of nucleotides: $nucleotides"
echo "$table"

