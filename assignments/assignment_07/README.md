# Assignment 7: Dog-Genome Read Mapping

This assignment used paired-end Illumina shotgun metagenomic reads to look for DNA that matches the dog reference genome. The workflow quality-filters reads, maps them to the *Canis familiaris* genome at 95% minimum identity, extracts mapped reads, and summarizes the results for each accession.

## Project overview

The pipeline was set up in this assignment directory and organized into separate scripts for downloading data, cleaning reads, mapping reads, and summarizing results. The final workflow is submitted through SLURM so it can run reproducibly on the cluster.

## Files and folders

- `data/` — raw accessions, curated SRA metadata, and processed read data
- `output/` — SLURM stdout/stderr logs
- `ref/` — reference genome and index files used for mapping
- `scripts/` — reusable workflow scripts
- `assignment_7_pipeline.slurm` — pipeline submission script
- `prompt_action_log.md` — documentation of project decisions and troubleshooting

## Tasks completed

### Task 1: Set up the assignment directory

- Created the assignment folder structure and project directories.
- Added this README, a script folder, and an output folder for cluster logs.
- Organized the project so download, QC, mapping, and summary steps are kept separate.

### Task 2: Download sequence data from SRA

- Used the validated metadata file [data/SraRunTableCorrect.csv](./data/SraRunTableCorrect.csv).
- Confirmed the accession list matched the assignment criteria for paired-end metagenomic Illumina data.
- Built a download script to fetch the paired reads with `fasterq-dump` and retrieve the dog reference genome.
- Kept the run table consistent across the workflow so all scripts process the same set of accessions.

### Task 3: Clean up the raw reads

- Created `scripts/02_clean_reads.sh` to process each sample in a loop.
- Used `fastp` to quality-filter and trim the paired-end reads.
- Stored cleaned reads in the project data directories and saved per-sample HTML/JSON QC reports.

### Task 4: Map clean reads to the dog genome

- Created `scripts/03_map_reads.sh` for the genome-mapping step.
- Used BBMap with `minid=0.95` to require at least 95% alignment identity.
- Mapped each cleaned sample against the dog reference genome and retained the mapped alignments.

### Task 5: Extract reads that matched the dog genome

- Continued the mapping step with `samtools`.
- Used `samtools view -F 4` to exclude unmapped reads and keep only reads with significant positive matches.
- Sorted and indexed the BAM files and generated per-sample flagstat summaries.

### Task 6: Submit the job to SLURM

- Built `assignment_7_pipeline.slurm` to run the full workflow in order.
- The pipeline calls the data download, read cleaning, and mapping scripts sequentially.
- Job output is sent to the `output/` directory so execution and errors can be inspected.

### Task 7: Inspect stdout and stderr

- Reviewed SLURM log files to confirm the pipeline status.
- Checked errors and job output to verify that file paths, tool usage, and sample processing were correct.

### Task 8: Inspect the results

- Summarized the number of QC-passing reads and reads mapped to the dog genome for each accession.
- The table below shows the final results from the successful pipeline run.

### Results summary

QC reads are the number of reads that passed `fastp`; mapped reads are the number of primary reads retained by `samtools flagstat` after filtering to mapped alignments. Both counts are reported as read counts rather than bases.

| Accession | QC reads (fastp) | Reads mapped to dog (95% identity) |
|---|---:|---:|
| SRR25358152 | 1,791,846 | 164 |
| SRR25358331 | 3,379,262 | 16 |
| SRR24991845 | 104,028,110 | 2,887 |
| SRR28772065 | 3,133,808 | 560 |
| SRR28772569 | 3,080,958 | 554 |
| SRR28772586 | 3,447,984 | 741 |
| ERR17724334 | 56,035,008 | 1,989 |
| ERR17724335 | 34,231,078 | 691 |
| DRR1001067 | 119,015,824 | 7,287 |
| DRR1001068 | 102,918,144 | 6,462 |

### Task 9: Document everything

- Added documentation in this README and the project log file.
- Recorded pipeline behavior, file locations, commands, and troubleshooting notes so the project is easy to follow.

### Run status

Job 610462 completed the pipeline for the ten accessions in the current run table. The current run table is [data/SraRunTableCorrect.csv](./data/SraRunTableCorrect.csv), and the results below reflect the values generated from that metadata file.

### Pipeline behavior

- `data/SraRunTableCorrect.csv` — current run table used by the pipeline
- `scripts/01_download_data.sh` — verifies the run table, downloads paired reads with `fasterq-dump`, and downloads/extracts the dog genome
- `scripts/02_clean_reads.sh` — trims and filters reads with `fastp` and saves per-sample QC reports
- `scripts/03_map_reads.sh` — maps reads to the dog reference genome using BBMap at 95% identity, keeps mapped reads with `samtools`, and writes flagstat summaries
- `scripts/04_summarize_results.py` — generates read-count summary output from the fastp JSON reports and mapping flagstats
- `assignment_7_pipeline.slurm` — submits the full workflow to SLURM with the required resource allocation

### How to run the pipeline

From this assignment directory:

```bash
sbatch assignment_7_pipeline.slurm
```

After the pipeline finishes, you can print the summary table with:

```bash
python scripts/04_summarize_results.py
```


### Task 10: Prepare the final project for GitHub

- Saved the completed workflow, scripts, results, and documentation in the repository for sharing and review.


## Personal reflection
This was definitely the hardest assignment for me to complete! I had trouble writing the code and using the correct tools for the analysis during this assignment, even with help from my 'robot servant'. The first couple of times I ran this assignment, I was not getting any output and that might've been because of how small my files were. I also struggled to find the correct type of data. I spend a lot of time finding data, downloading the Sra Table, putting the Table on the hpc only to realize that it didn't work. I had multiple times when I was running this pipeline (with some variation from the one presented here) where I ran out of time. One time I even ran out of time when the time limit was 2 days. This is because I didn't have the right type of data. The run for this attempt took significantly less time, but still took about 13 hours for the full completion of the pipeline. I definitely sturggled through this assignment, but through the struggle I learned about what type of data I need to make sure I have, and different time allotments on the hpc. I also learned about what it is like to have an AI agent write code for me and what prompting an AI agent looks like during this assignment. 