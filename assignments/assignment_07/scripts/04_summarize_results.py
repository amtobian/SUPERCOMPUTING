#!/usr/bin/env python3
"""Print per-sample fastp and dog-mapping read counts as a Markdown table."""

import csv
import json
import os
import re
import sys
from pathlib import Path


PROJECT_DIR = Path(__file__).resolve().parents[1]
DATA_DIR = Path(
    os.environ.get(
        "PIPELINE_DATA_DIR",
        "/sciclone/home/amtobian/scr10/assignment_07/data",
    )
)
RUN_TABLE = PROJECT_DIR / "data" / "SraRunTableCorrect.csv"
OUTPUT_DIR = DATA_DIR / "mapped"
CLEAN_DIR = DATA_DIR / "clean"


def fastp_counts_from_logs(accessions):
    """Recover counts from existing pipeline logs written before per-sample JSON."""
    counts = {}
    passed_reads = None
    command_pattern = re.compile(
        r"fastp --in1 \S*/([^/\s]+)_1\.fastq(?:\.gz)?(?:\s|$)"
    )
    count_pattern = re.compile(r"reads passed filter:\s*(\d+)")

    for log_path in sorted((PROJECT_DIR / "output").glob("*_pipeline_*.err")):
        with log_path.open(encoding="utf-8", errors="replace") as log:
            for line in log:
                count_match = count_pattern.search(line)
                if count_match:
                    passed_reads = int(count_match.group(1))
                    continue
                command_match = command_pattern.search(line)
                if command_match:
                    accession = command_match.group(1)
                    if accession in accessions and passed_reads is not None:
                        counts[accession] = passed_reads
                    passed_reads = None
    return counts


def read_fastp_counts(accessions):
    counts = {}
    for accession in accessions:
        report_path = CLEAN_DIR / f"{accession}_fastp.json"
        if not report_path.is_file():
            continue
        with report_path.open(encoding="utf-8") as report:
            data = json.load(report)
        try:
            counts[accession] = int(data["summary"]["after_filtering"]["total_reads"])
        except (KeyError, TypeError, ValueError) as error:
            raise ValueError(f"Invalid fastp report: {report_path}") from error

    for accession, count in fastp_counts_from_logs(accessions).items():
        counts.setdefault(accession, count)
    return counts


def read_mapped_counts(accessions):
    counts = {}
    for accession in accessions:
        report_path = OUTPUT_DIR / f"{accession}_minid95_flagstat.txt"
        if not report_path.is_file():
            continue
        with report_path.open(encoding="utf-8") as report:
            for line in report:
                match = re.match(r"(\d+) \+ \d+ primary mapped\b", line)
                if match:
                    counts[accession] = int(match.group(1))
                    break
    return counts


def main():
    if not RUN_TABLE.is_file():
        raise FileNotFoundError(f"Run table not found: {RUN_TABLE}")

    with RUN_TABLE.open(newline="", encoding="utf-8-sig") as table_file:
        reader = csv.DictReader(table_file)
        if not reader.fieldnames or "Run" not in reader.fieldnames:
            raise ValueError(f"Run table must have a 'Run' column: {RUN_TABLE}")
        accessions = [
            row["Run"].strip()
            for row in reader
            if row.get("Run") and row["Run"].strip()
        ]

    if not accessions:
        raise ValueError(f"No accessions found in run table: {RUN_TABLE}")

    qc_counts = read_fastp_counts(accessions)
    mapped_counts = read_mapped_counts(accessions)
    missing = [
        f"{accession} (QC)"
        for accession in accessions
        if accession not in qc_counts
    ] + [
        f"{accession} (mapped)"
        for accession in accessions
        if accession not in mapped_counts
    ]
    if missing:
        raise FileNotFoundError(
            "Missing per-sample counts: "
            + ", ".join(missing)
            + ". Run the cleaning/mapping steps first; QC counts may also be "
            "recovered from output/*_pipeline_*.err."
        )

    print("| Accession | QC reads passed | Reads mapped to dog |")
    print("|---|---:|---:|")
    for accession in accessions:
        print(
            f"| {accession} | {qc_counts[accession]:,} | "
            f"{mapped_counts[accession]:,} |"
        )


if __name__ == "__main__":
    try:
        main()
    except (OSError, ValueError, json.JSONDecodeError) as error:
        print(f"ERROR: {error}", file=sys.stderr)
        sys.exit(1)
