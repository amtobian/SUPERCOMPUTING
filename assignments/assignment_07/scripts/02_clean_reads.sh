#!/bin/bash
set -euo pipefail


PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$PROJECT_DIR"

DATA_DIR="${PIPELINE_DATA_DIR:-/sciclone/home/amtobian/scr10/assignment_07/data}"
RUN_TABLE="$PROJECT_DIR/data/SraRunTableAMP.csv"
RAW_DIR="$DATA_DIR/raw"
CLEAN_DIR="$DATA_DIR/clean"
THREADS="${SLURM_CPUS_PER_TASK:-4}"

if [[ ! -s "$RUN_TABLE" ]]; then
    echo "ERROR: Run table not found or empty: $RUN_TABLE" >&2
    exit 1
fi

mkdir -p "$CLEAN_DIR"

if [[ ! "$THREADS" =~ ^[1-9][0-9]*$ ]]; then
    echo "ERROR: Invalid thread count: $THREADS" >&2
    exit 1
fi

if ! command -v fastp >/dev/null 2>&1; then
    echo "ERROR: fastp not found. Check your PATH." >&2
    exit 1
fi

while IFS= read -r accession; do
    accession="${accession%$'\r'}"
    [[ -z "$accession" ]] && continue
    # Build input and output filenames inside the loop.
    base="$accession"
    in1="$RAW_DIR/${base}_1.fastq.gz"
    in2="$RAW_DIR/${base}_2.fastq.gz"
    out1="$CLEAN_DIR/${base}_1.fastq.gz"
    out2="$CLEAN_DIR/${base}_2.fastq.gz"
    tmp1="$CLEAN_DIR/.${base}_1.partial.fastq.gz"
    tmp2="$CLEAN_DIR/.${base}_2.partial.fastq.gz"

    if [[ ! -s "$in1" ]]; then
        echo "ERROR: Matching forward read not found or empty: $in1" >&2
        exit 1
    fi

    if [[ ! -s "$in2" ]]; then
        echo "ERROR: Matching reverse read not found or empty: $in2" >&2
        exit 1
    fi

    # Existing completed pairs are reused; new output files are staged so an
    # interrupted fastp run cannot be mistaken for a completed sample.
    if [[ -s "$out1" && -s "$out2" ]]; then
        echo "Skipping $base; both cleaned read files already exist."
        continue
    fi

    echo "Cleaning sample: $base"
    rm -f -- "$tmp1" "$tmp2"

    fastp \
        --in1 "$in1" \
        --in2 "$in2" \
        --out1 "$tmp1" \
        --out2 "$tmp2" \
        --thread "$THREADS" \
        > /dev/null

    if [[ ! -s "$tmp1" || ! -s "$tmp2" ]]; then
        echo "ERROR: fastp did not produce both cleaned files for $base." >&2
        exit 1
    fi

    mv -f -- "$tmp1" "$out1"
    mv -f -- "$tmp2" "$out2"
done < <(tail -n +2 "$RUN_TABLE" | cut -d ',' -f 1)

echo "Read cleaning complete!"
