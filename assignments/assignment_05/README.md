### Allie Tobian
### Assignment 5 
### 9/29/2026 

# Completing the Assignment 

## Task 1
This is completed in ~/SUPERCOMPUTING/assignments/assignment_05 with the structure of the folders in this folder that is both on the supercomputer 
and has been pushed to github. 
## Task 2
To do this task I first ran the commands locally on my computer and recorded the commands that worked in a notepad file. 
After I had found the commands that worked for me, I wrote them in the bash script. This script can be found in ~/SUPERCOMPUTING/assignments/assignment_05/scripts/01_download_data.sh

## Task 3
I am using fastp version 1.3.7 for this assignment. fastp is located in ~/programs. 
The steps that I used to download fastp are below. 
1. wget http://opengene.org/fastp/fastp.1.3.3
2. mv fastp.1.3.3 fastp
3. chmod a+x ./fast
4. echo 'export PATH = $PATH:~/programs/fastp' >> ~/.bashrc

## Task 4 - RUN FASTP.SH
The script for this task is located in ~/SUPERCOMPUTING/assignments/assignment_05/scripts/02_run_fastp.sh
This script takes a file in the in direction and creates the matching reverse, forward out, and reverse out files. 
After completing that using command substitution, this file uses the in1, out1, in2, out2, and reads the files. 
After the files have been read, it removes the first 9 bases from forward, removes the first 
8 bases from reverse, removes the last 20 bases from forward, and removes the last 20 bases from reverse. 
Then this script removes any reads with "N" and any reads shorter than 100nt. Lastly this script discards reads of <20 average quality.
This script uses the fastp software to complete this. If fastp is not already downloaded,
than this script would not work. To download fastp follow the steps outlined in task 4 above. 

## Task 5 - The PIPELINE
The script for this task is located in ~/SUPERCOMPUTING/assignments/assignment_05/pipeline.sh

The Pipeline runs two different scripts. The first script it runs is 01_download_data.sh
The second script it runs is 02_run_fastp.sh. However it runs _02_run_fastp.sh in a loop over all of the files that are 
*_R1_* in the folder assignment_05/data/raw. The output of the work is printed to the screen and the files are placed in assignment_05/data/trimmed

# My Reflection 
This again was a hard assignment to complete. Even though I have done practice assignments 1-3 
the command substition and bash scripts are still hard for me to understand. 
My understanding of why this is split up into two scripts and then called with the overall pipeline, is so that if there are issues 
in one place it is easier to find and replace as the scripts can be tested seperately. I used this when testing. First I made sure both of my scripts were working
individually before I began to write and test pipeline.sh, as I had multiple little errros in pipeline.sh. I new these errors were in the for loop when writing pipeline.sh because i already knew 01_download_data.sh and 02_run_fastp.sh were working.
 However the cons of this approach is that multiple files are needed to be named and in the right place for 
someone to run pipeline.sh. If someone was totally new at running bash commands having multiple files makes it much harder for them. 
During this assignment I learned about .gitignore when I was pushing to github (It worked quite nicely, I would recommend using it with the file paths to large data folders.) 
I also reviewed command substitution when creating FWD_IN, REV_IN, FWD_OUT, and REV_OUT. 
Furthermore, I practiced writing multi-step scripts. 
