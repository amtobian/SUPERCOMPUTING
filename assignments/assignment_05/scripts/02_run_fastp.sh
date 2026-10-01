#!/bin/bash
set -ueo pipefail

# set input 
FWD_IN=$1
REV_IN=${FWD_IN/_R1_/_R2_}

# set output
FWD_OUT=${FWD_IN/raw/trimmed}
FWD_OUT=${FWD_OUT/.fastq.gz/.trimmed.fastq.gz}
REV_OUT=${REV_IN/raw/trimmed}
REV_OUT=${REV_OUT/.fastq.gz/.trimmed.fastq.gz}

# do fastp

fastp \
-i "$FWD_IN" \
-o "$FWD_OUT" \
-I "$REV_IN" \
-O "$REV_OUT" \
-j /dev/null \
-h /dev/null \
-f 8 \
-F 8 \
-t 20 \
-T 20 \
--n_base_limit 0 \
--length_required 100 \
--average_qual 20
