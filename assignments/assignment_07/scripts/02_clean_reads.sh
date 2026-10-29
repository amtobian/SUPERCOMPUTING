#!/bin/bash
set -euo pipefail


PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$PROJECT_DIR"

RAW_DIR="./data/raw"
CLEAN_DIR="./data/clean"

mkdir -p "$CLEAN_DIR"

if ! command -v fastp >/dev/null 2>&1; then
    echo "ERROR: fastp not found. Check your PATH."
    exit 1
fi

for in1 in "$RAW_DIR"/*_1.fastq.gz; do
    [[ -f "$in1" ]] || continue

    # Build input and output filenames inside the loop.
    base=$(basename "$in1" _1.fastq.gz)
    in2="$RAW_DIR/${base}_2.fastq.gz"
    out1="$CLEAN_DIR/${base}_1.fastq.gz"
    out2="$CLEAN_DIR/${base}_2.fastq.gz"

    if [[ ! -f "$in2" ]]; then
        echo "ERROR: Matching reverse read not found: $in2"
        exit 1
    fi

    echo "Cleaning sample: $base"

    fastp \
        --in1 "$in1" \
        --in2 "$in2" \
        --out1 "$out1" \
        --out2 "$out2" \
        --thread 4 \
        > /dev/null
done

echo "Read cleaning complete!"
