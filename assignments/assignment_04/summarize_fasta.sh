#!/bin/bash
set -ueo pipefail

# accepts the name of a fasta file as a positional argument and store as a variable
file = "$1"

# calculates total number of sequences
sequences=$(seqtk comp "$file" | wc -l)

# calculautes total number of nucleotides
nucleotides=$(seqtk comp "$file" | wc -m)

# table of sequences names and lengths

# reports information to stdout with explanations
