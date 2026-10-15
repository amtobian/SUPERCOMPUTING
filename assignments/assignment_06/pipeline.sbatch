#!/bin/bash
#SBATCH --job-name=flye_module
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=6
#SBATCH --mem=16G
#SBATCH --time=30
#SBATCH --mail-type=BEGIN,END,FAIL,TIME_LIMIT
#SBATCH --mail-user=amtobian@wm.edu
#SBATCH --output=flye_module_%j.out
#SBATCH --error=flye_module_%j.err


set -ueo pipefail

# run setup scripts
bash ./scripts/01_download_data.sh
bash ./scripts/02_flye_2.9.6_conda_install.sh
bash ./scripts/02_flye_2.9.6_manual_build.sh

# run flye all three ways
bash ./scripts/03_run_flye_conda.sh
bash ./scripts/03_run_flye_local.sh
bash ./scripts/03_run_flye_module.sh

# compare last lines
for log in \
assemblies/assembly_local/local_flye.log \
assemblies/assembly_conda/conda_flye.log \
assemblies/assembly_module/module_flye.log
do
echo "===========$log================="
tail -n 10 "$log"
echo
done
