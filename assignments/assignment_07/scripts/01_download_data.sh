#!/bin/bash
set -euo pipefail

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$PROJECT_DIR"

DATA_DIR="${PIPELINE_DATA_DIR:-/sciclone/home/amtobian/scr10/assignment_07/data}"
RUN_TABLE="$PROJECT_DIR/data/SraRunTableCorrect.csv"
RAW_DIR="$DATA_DIR/raw"
REFERENCE_DIR="$DATA_DIR/dog_reference"
TEMP_DIR="$DATA_DIR/tmp"

if [[ ! -s "$RUN_TABLE" ]]; then
    echo "ERROR: Run table not found or empty: $RUN_TABLE" >&2
    exit 1
fi

mkdir -p "$RAW_DIR" "$REFERENCE_DIR" "$TEMP_DIR"

# Download raw sequencing reads. Keep each download isolated until fasterq-dump
# succeeds so an interrupted run cannot leave partial files in the final paths.
while IFS= read -r accession; do
    accession="${accession%$'\r'}"
    [[ -z "$accession" ]] && continue
    if [[ ! "$accession" =~ ^[[:alnum:]_-]+$ ]]; then
        echo "ERROR: Invalid accession: $accession" >&2
        exit 1
    fi

    read1="$RAW_DIR/${accession}_1.fastq"
    read2="$RAW_DIR/${accession}_2.fastq"
    gzip1="$read1.gz"
    gzip2="$read2.gz"
    marker="$RAW_DIR/.${accession}.download_complete"

    ready1=false
    ready2=false
    [[ -s "$read1" || -s "$gzip1" ]] && ready1=true
    [[ -s "$read2" || -s "$gzip2" ]] && ready2=true

    if [[ "$ready1" == true && "$ready2" == true ]]; then
        if [[ ! -e "$marker" ]]; then
            valid_existing=true
            if [[ ! -s "$read1" && -s "$gzip1" ]]; then
                gzip -t -- "$gzip1" || valid_existing=false
            fi
            if [[ ! -s "$read2" && -s "$gzip2" ]]; then
                gzip -t -- "$gzip2" || valid_existing=false
            fi

            if [[ "$valid_existing" == true ]]; then
                : > "$marker"
            else
                ready1=false
                ready2=false
            fi
        fi
    fi

    if [[ "$ready1" == true && "$ready2" == true && -e "$marker" ]]; then
        echo "Skipping ${accession}; complete read files already exist."
        continue
    fi

    echo "Downloading ${accession}..."
    staging_dir="$RAW_DIR/.${accession}.partial"
    rm -rf -- "$staging_dir"
    mkdir -p "$staging_dir"
    rm -f -- "$marker"

    fasterq-dump "$accession" \
        --outdir "$staging_dir" \
        --temp "$TEMP_DIR" \
        --threads 4

    staged_read1="$staging_dir/${accession}_1.fastq"
    staged_read2="$staging_dir/${accession}_2.fastq"
    if [[ ! -s "$staged_read1" || ! -s "$staged_read2" ]]; then
        echo "ERROR: fasterq-dump did not produce both read files for $accession." >&2
        exit 1
    fi

    mv -f -- "$staged_read1" "$read1"
    mv -f -- "$staged_read2" "$read2"
    rm -rf -- "$staging_dir"
    : > "$marker"
    echo "Finished ${accession}"
done < <(tail -n +2 "$RUN_TABLE" | cut -d ',' -f 1)

# Compress uncompressed reads using all allocated CPUs when pigz is available.
shopt -s nullglob
fastq_files=("$RAW_DIR"/*.fastq)
if (( ${#fastq_files[@]} > 0 )); then
    if command -v pigz >/dev/null 2>&1; then
        compression_threads="${SLURM_CPUS_PER_TASK:-4}"
        if [[ ! "$compression_threads" =~ ^[1-9][0-9]*$ ]]; then
            echo "ERROR: Invalid SLURM_CPUS_PER_TASK: $compression_threads" >&2
            exit 1
        fi
        echo "Compressing FASTQ files with pigz using ${compression_threads} threads..."
        pigz -f -p "$compression_threads" -- "${fastq_files[@]}"
    else
        echo "pigz is unavailable; compressing FASTQ files with gzip."
        gzip -f -- "${fastq_files[@]}"
    fi
fi

# Download the Canis familiaris reference genome if it is not already present.
if [[ -s "$REFERENCE_DIR/dog_reference_genome.fna" ]]; then
    echo "Skipping dog reference download; genome already exists."
else
    echo "Downloading dog reference genome..."

    datasets download genome taxon "Canis familiaris" \
        --reference \
        --include genome \
        --filename "$REFERENCE_DIR/dog_reference.zip"

    # Extract the reference genome package
    unzip -o "$REFERENCE_DIR/dog_reference.zip" \
        -d "$REFERENCE_DIR/ncbi_dataset"

    # Find and copy the genomic FASTA to the required filename
    reference=$(find "$REFERENCE_DIR/ncbi_dataset" \
        -type f -name '*_genomic.fna' -print -quit)

    if [[ -z "$reference" ]]; then
        echo "Error: Reference genome FASTA not found."
        exit 1
    fi

    cp "$reference" "$REFERENCE_DIR/dog_reference_genome.fna"

    # Remove the downloaded archive and extracted package
    rm -rf "$REFERENCE_DIR/dog_reference.zip"
    rm -rf "$REFERENCE_DIR/ncbi_dataset"
fi

echo "All downloads complete!"
