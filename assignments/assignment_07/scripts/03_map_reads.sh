#!/bin/bash
set -euo pipefail

# ============================================================
# Script: 03_map_reads.sh
# Purpose: Align cleaned reads to the dog reference genome
#          and retain mapped reads.
#
# Input:  data/clean/
# Reference: data/dog_reference/dog_reference_genome.fna
# Output: data/mapped/
#
# Alignment: BWA-MEM
# Filtering: samtools view -F 4 excludes unmapped reads
# ============================================================

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$PROJECT_DIR"

CLEAN_DIR="./data/clean"
REFERENCE="./data/dog_reference/dog_reference_genome.fna"
OUTPUT_DIR="./data/mapped"

mkdir -p "$OUTPUT_DIR"

# Check required programs
for program in bwa samtools; do
    if ! command -v "$program" >/dev/null 2>&1; then
        echo "ERROR: $program not found."
        exit 1
    fi
done

if [[ ! -f "$REFERENCE" ]]; then
    echo "ERROR: Reference genome not found: $REFERENCE"
    exit 1
fi

# Build the BWA reference index if it does not exist
if [[ ! -f "${REFERENCE}.bwt" ]]; then
    echo "Indexing dog reference genome..."
    bwa index "$REFERENCE"
fi

# Loop through cleaned forward reads
for in1 in "$CLEAN_DIR"/*_1.fastq.gz; do
    [[ -f "$in1" ]] || continue

    # Build paired input filenames inside the loop
    base=$(basename "$in1" _1.fastq.gz)
    in2="$CLEAN_DIR/${base}_2.fastq.gz"

    if [[ ! -f "$in2" ]]; then
        echo "ERROR: Matching reverse read not found: $in2"
        exit 1
    fi

    echo "Aligning sample: $base"

    # Align reads and retain mapped alignments
    bwa mem -t 4 "$REFERENCE" "$in1" "$in2" |
        samtools view -b -F 4 - |
        samtools sort -o "$OUTPUT_DIR/${base}_mapped.bam"

    # Index the resulting BAM file
    samtools index "$OUTPUT_DIR/${base}_mapped.bam"

    echo "Finished sample: $base"
done

echo "Read mapping complete!"
