#!/bin/bash
set -ueo pipefail

# local build without installation

# move into programs directory
cd ~/programs 

#clone flye
git clone https://github.com/fenderglass/Flye

# move into repo
cd Flye

# build
make

# set file path
echo 'export PATH="$PATH:/sciclone/home/amtobian/programs/Flye/bin"' >> ~/.bashrc

