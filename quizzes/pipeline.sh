#!/bin/bash
set -ueo pipefail

# run script 1
bash ./scripts/01_prep_data.sh

# run script 2
bash ./scripts/02_get_stats.sh

# run script 3
bash ./scripts/03_cleanup.sh
