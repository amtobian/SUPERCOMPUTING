# Prompt/action log

- 2026-11-05 — Request: read `INSTRUCTIONS.md` and `AGENTS.md`, complete the
  assignment, and diagnose why the pipeline exceeded the expected three hours.
  Model/version: unavailable. Read the instructions, scripts, metadata, and
  SLURM logs; identified the oversized/mismatched dataset, four-thread
  hard-coding, missing 95% BBMap identity setting, and lack of mapping resume;
  updated the SLURM paths, fastp/BBMap thread handling and mapping checkpoint
  behavior, and documented measured timings and incomplete results in the
  README. No job was submitted and no input data or accession metadata was
  changed.
- 2026-11-05 — Follow-up: keep the current CSV and finish documentation and
  diagnosis; the user will fix the data. Model/version: unavailable. Recorded
  that decision, documented the fastp defaults/report limitation, and verified
  the metadata file remained unchanged. No data or jobs were modified/launched.
- 2026-11-05 — Follow-up: user supplied the updated run table and asked where
  to point the scripts and whether the data meet the criteria. Model/version:
  unavailable. Verified all 11 rows are paired Illumina WGS random
  metagenomic; updated download, cleaning, and mapping scripts to use
  `data/SraRunTableFinal1.csv` and process only those accessions. Updated the
  README with new metadata totals and noted that existing scratch files belong
  to the old accessions. Did not delete or overwrite data or submit a job.
- 2026-11-06 — Follow-up: user changed the run table and asked to update
  everything. Model/version: unavailable. Inspected `SraRunTableAMP.csv`;
  confirmed 10 rows are labeled AMPLICON, one is single-end, and one has
  GENOMIC source, so this table does not meet the assignment requirements.
  Updated all three scripts to reference the new filename, added an early
  validation stop before downloading invalid data, and revised the README.
  Did not change the CSV, delete old data, or submit a job.
