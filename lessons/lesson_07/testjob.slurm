#!/bin/bash
#SBATCH --job-name=test_hello
#SBATCH --nodes=1
#SBATCH --ntasks=1 
#SBATCH --cpus-per-task=1 
#SBATCH --time=1
#SBATCH --mem=1G 
#SBATCH --mail-type=FAIL,BEGIN,END
#SBATCH --mail-user=amtobian@wm.edu
#SBATCH -o test_hello_%j.out
#SBATCH -e test_hello_%j.err

echo "Hello world!" # code to run (could be a .sh script or series)
