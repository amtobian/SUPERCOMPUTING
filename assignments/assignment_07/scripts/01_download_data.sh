#!/bin/bash
set -euo pipefail

# Download raw sequencing reads
tail -n +2 data/SraRunTable.csv | cut -d ',' -f 1 | while read -r accession
do
    echo "Downloading ${accession}..."

    fasterq-dump "$accession" \
        --outdir data/raw \
        --threads 4

    echo "Finished ${accession}"
done

# Compress raw FASTQ files
gzip data/raw/*.fastq

# Download the Canis familiaris reference genome
echo "Downloading dog reference genome..."

datasets download genome taxon "Canis familiaris" \
    --reference \
    --include genome \
    --filename data/dog_reference/dog_reference.zip

# Extract the reference genome package
unzip -o data/dog_reference/dog_reference.zip \
    -d data/dog_reference/ncbi_dataset

# Find and copy the genomic FASTA to the required filename
reference=$(find data/dog_reference/ncbi_dataset \
    -type f -name '*_genomic.fna' -print -quit)

if [[ -z "$reference" ]]; then
    echo "Error: Reference genome FASTA not found."
    exit 1
fi

cp "$reference" data/dog_reference/dog_reference_genome.fna

# Remove the downloaded archive and extracted package
rm -rf data/dog_reference/dog_reference.zip
rm -rf data/dog_reference/ncbi_dataset

echo "All downloads complete!"

