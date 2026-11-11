#!/bin/bash
set -euo pipefail

# ============================================================
# Script: 03_map_reads.sh
# Purpose: Align cleaned reads to the dog reference genome
#          and retain mapped reads.
#
# Input:  $DATA_DIR/clean/
# Reference: $DATA_DIR/dog_reference/dog_reference_genome.fna
# Output: $DATA_DIR/mapped/
#
# Alignment: BBMap
# Filtering: samtools view -F 4 excludes unmapped reads
# ============================================================

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$PROJECT_DIR"

DATA_DIR="${PIPELINE_DATA_DIR:-/sciclone/home/amtobian/scr10/assignment_07/data}"
RUN_TABLE="$PROJECT_DIR/data/SraRunTableCorrect.csv"
CLEAN_DIR="$DATA_DIR/clean"
REFERENCE="$DATA_DIR/dog_reference/dog_reference_genome.fna"
OUTPUT_DIR="$DATA_DIR/mapped"
THREADS="${SLURM_CPUS_PER_TASK:-4}"
SORT_THREADS=4

if [[ ! -s "$RUN_TABLE" ]]; then
    echo "ERROR: Run table not found or empty: $RUN_TABLE" >&2
    exit 1
fi

mkdir -p "$OUTPUT_DIR"

if [[ ! "$THREADS" =~ ^[1-9][0-9]*$ ]]; then
    echo "ERROR: Invalid thread count: $THREADS" >&2
    exit 1
fi

# Check required programs
for program in bbmap.sh samtools; do
    if ! command -v "$program" >/dev/null 2>&1; then
        echo "ERROR: $program not found." >&2
        exit 1
    fi
done

if [[ ! -s "$REFERENCE" ]]; then
    echo "ERROR: Reference genome not found or empty: $REFERENCE" >&2
    exit 1
fi

# Loop through cleaned forward reads
while IFS= read -r accession; do
    accession="${accession%$'\r'}"
    [[ -z "$accession" ]] && continue
    # Build paired input filenames inside the loop
    base="$accession"
    in1="$CLEAN_DIR/${base}_1.fastq.gz"
    in2="$CLEAN_DIR/${base}_2.fastq.gz"
    output_bam="$OUTPUT_DIR/${base}_minid95_mapped.bam"
    output_bai="$output_bam.bai"
    tmp_bam="$OUTPUT_DIR/.${base}_minid95.partial.bam"
    tmp_bai="$tmp_bam.bai"
    bbmap_log="$OUTPUT_DIR/${base}_minid95_bbmap.log"
    flagstat="$OUTPUT_DIR/${base}_minid95_flagstat.txt"

    if [[ ! -s "$in1" ]]; then
        echo "ERROR: Matching cleaned forward read not found or empty: $in1" >&2
        exit 1
    fi

    if [[ ! -s "$in2" ]]; then
        echo "ERROR: Matching reverse read not found or empty: $in2" >&2
        exit 1
    fi

    # The distinct minid95 filename prevents old default-identity results from
    # being reused as if they met the assignment's 95% identity requirement.
    if [[ -s "$output_bam" && -s "$output_bai" ]]; then
        if [[ ! -s "$flagstat" ]]; then
            samtools flagstat -@ "$SORT_THREADS" "$output_bam" > "$flagstat"
        fi
        echo "Skipping $base; completed 95%-identity BAM already exists."
        continue
    fi

    echo "Aligning sample: $base"
    rm -f -- "$tmp_bam" "$tmp_bai"

    # Keep only alignments meeting the assignment's 95% minimum identity.
    bbmap.sh ref="$REFERENCE" in="$in1" in2="$in2" \
        threads="$THREADS" minid=0.95 out=stdout.sam 2> "$bbmap_log" |
        samtools view -u -F 4 - |
        samtools sort -@ "$SORT_THREADS" -o "$tmp_bam" -

    if [[ ! -s "$tmp_bam" ]]; then
        echo "ERROR: Mapping did not produce a BAM file for $base." >&2
        exit 1
    fi

    samtools index -@ "$SORT_THREADS" "$tmp_bam"
    mv -f -- "$tmp_bam" "$output_bam"
    mv -f -- "$tmp_bai" "$output_bai"
    samtools flagstat -@ "$SORT_THREADS" "$output_bam" > "$flagstat"

    echo "Finished sample: $base; flagstat: $flagstat"
done < <(tail -n +2 "$RUN_TABLE" | cut -d ',' -f 1)

echo "Read mapping complete!"
