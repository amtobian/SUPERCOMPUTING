# Assignment 7: Dog-Genome Read Mapping

## Goal

Quality-filter paired-end Illumina shotgun metagenomic reads, map them to the
*Canis familiaris* reference genome with at least 95% identity, and retain the
mapped reads with samtools.

## Current run table: not eligible for this assignment

The current Run Selector export is [data/SraRunTableAMP.csv](./data/SraRunTableAMP.csv)
and contains 10 runs. Although the runs are Illumina and report random library
selection, the metadata labels **all 10 as `Assay Type=AMPLICON`**. One run also
reports `LibrarySource=GENOMIC` rather than `METAGENOMIC`, and one run is
`SINGLE` rather than `PAIRED`.

The instructions explicitly ask for random shotgun metagenomic data and say
not to use amplicons. Therefore, this table does **not** meet the assignment's
criteria and should not be used for the final run. To prevent accidentally
using it, `01_download_data.sh` now checks the metadata before downloading and
stops with an error unless all rows are paired `WGS`, `RANDOM`,
`METAGENOMIC`, `ILLUMINA` runs. The other scripts also point to this same
filename. Replace this CSV with a qualifying table before submitting the
pipeline.

This table reports about **458 million bases** and **171 MB** in the SRA
`Bytes` field. Those small totals may explain why an amplicon workflow would
finish much faster, but a fast result on this table would not satisfy the
assignment. The exact SRA search string is not recorded in the repository.

## Previous run and current data

The previous SLURM log is from a different accession selection. It showed
fastp taking 3.58 hours for 13 old accessions, and BBMap taking 12.31 hours for
one old sample (47 million reads) with four mapping threads, before SLURM
cancelled the job at the two-day limit. Those timings are not an estimate for
this new table.

The working data directory at `/sciclone/home/amtobian/scr10/assignment_07/data`
may still contain raw, cleaned, and mapped files from the older selections.
They have not been deleted. The download script will refuse the current
ineligible table before starting; after replacing it with a valid paired
shotgun table, the scripts iterate only over the accessions in that table.

## Pipeline files and behavior

- `data/SraRunTableAMP.csv` — current Run Selector export. Replace its contents
  with a qualifying table before running the pipeline.
- `scripts/01_download_data.sh` — validates the run table, downloads paired
  reads with `fasterq-dump`, compresses them, and downloads/extracts the
  reference genome.
- `scripts/02_clean_reads.sh` — runs fastp for each listed accession. It uses
  fastp defaults for trimming/filtering and the SLURM CPU allocation for
  threads. No explicit quality, length, or adapter options are passed.
- `scripts/03_map_reads.sh` — maps each listed pair using BBMap `minid=0.95`,
  retains mapped alignments with `samtools view -F 4`, then sorts and indexes
  the BAM. It writes a per-accession `samtools flagstat` report.
- `assignment_7_pipeline.slurm` — requests 20 CPUs, 120 GB RAM, and two days on
  Bora. fastp and BBMap use the allocated CPU count; samtools sorting uses four
  threads. SLURM stdout and stderr go to `output/`.

The scripts use `/sciclone/home/amtobian/scr10/assignment_07/data` for large
inputs and intermediate data. After replacing the table with valid metadata,
submit from this assignment directory on the development server after
selecting the intended SLURM cluster:

```bash
sbatch assignment_7_pipeline.slurm
```

The updated pipeline has not been run against the current table. The previous
run used BBMap's automatic Java heap, which was 56 GB in its log; it did not
fail for lack of memory. The observed blocker was processing time.

## Results

No final QC or mapped-read counts are available for the current table. Do not
report amplicon results as the requested shotgun metagenome results. After a
valid table is supplied and the pipeline completes, use the per-run
`*_minid95_flagstat.txt` reports in the mapped data directory to populate this
table. `samtools flagstat` reports alignment counts; use the same definition
for every sample.

| Accession | QC reads (fastp) | Reads mapped to dog (95% identity) |
|---|---:|---:|
| Pending valid metadata and pipeline run | — | — |

## Reflection

The main challenge was diagnosing why the previous run took far longer than
expected: the old data set was very large, and both fastp and BBMap used only
four threads despite a 20-CPU SLURM request. I learned to check accession
metadata against the scientific question, including assay type and read
layout, and to make scripts stop before processing a dataset that does not
meet the assignment criteria. The current table is smaller but is labeled
amplicon, so the final analysis remains pending a qualifying shotgun dataset.
