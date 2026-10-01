#!/bin/bash
set -ueo pipefail

# download data by running scripts/01_download_data.sh

bash ./scripts/01_download_data.sh

# for loop to run fastp on each file in data 

for FILE in ./data/raw/*_R1_*
do
bash ./scripts/02_run_fastp.sh "$FILE"
done

