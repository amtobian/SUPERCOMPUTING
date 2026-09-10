Allie TObian 

9/9/2026

Assignment 02


# Task 2: Download Files from NCB via Command-Line FTP 

ftp ftp.ncbi.nlm.nih.gov
anonymous  (username) 
amtobian@wm.edu  (password)

cd genomes
cd all 
cd GCF
cd 000
cd 005
cd 845
cd GCF
cd GCF_000005845.2_ASM584v2

get GCF_000005845.2_ASM584v2_genomic.fna.gz
get GCF_000005845.2_ASM584v2_genomic.gff.gz

bye
(bye command exits ftp, you are now in your local system) 
# Move Files to the correct location in SUPERCOMPUTING/assignments/assignment_02/data
(note: I downloaded these two files into my supercomputing folder so I just moved from there) 
mv GCF_000005845.2_ASM584v2_genomic.fna.gz assignments
mv GCF_000005845.2_ASM584v2_genomic.fna.gz assignment_02
mv GCF_000005845.2_ASM584v2_genomic.fna.gz data

(go back to the SUPERCOMPUTING folder and move the other file) 

mv GCF_000005845.2_ASM584v2_genomic.gff.gz assignments
mv GCF_000005845.2_ASM584v2_genomic.gff.gz assignment_02
mv GCF_000005845.2_ASM584v2_genomic.gff.gz data


# Task 3: File Transfer 
In WinSCP
log in
navigate to location where files are on left side and where you want to move them (right side) 
drag and drop files 

# Make the Files world readable 
In SUPERCOMPUTING/assignments/assignment_02/data 
chmod a+r GCF_000005845.2_ASM584v2_genomic.fna.gz
chmod a+r GCF_000005845.2_ASM584v2_genomic.gff.gz


# Task 4: md5sum file integrity 
# On Local Computer 
(in SUPERCOMPUTING/assignments/assignment_02/data

md5sum GCF_000005845.2_ASM584v2_genomic.fna.gz
c13d459b5caa702ff7e1f26fe44b8ad7 *GCF_000005845.2_ASM584v2_genomic.fna.gz

md5sum GCF_000005845.2_ASM584v2_genomic.gff.gz
0f52ffc94af5ddf544ff89cc6f546b0c *GCF_000005845.2_ASM584v2_genomic.gff.gz

# On HPC (SUPERCOMPUTER) 
md5sum GCF_000005845.2_ASM584v2_genomic.fna.gz
c13d459b5caa702ff7e1f26fe44b8ad7  GCF_000005845.2_ASM584v2_genomic.fna.gz


md5sum GCF_000005845.2_ASM584v2_genomic.gff.gz
0f52ffc94af5ddf544ff89cc6f546b0c  GCF_000005845.2_ASM584v2_genomic.gff.gz

# My response to file integrity
the md5sum hashes for the files have the same numerical and characters for both files.
However on my local computer, there is a * before the name of the file. 
I have looked this up, and I believe that it is just something about the file format and that 
the contents will still be identical. I used WinSCP instead of FireZilla but I believe that 
I did not corrupt the files when I moved them onto the supercomputer. 

# Bash Aliases 

alias u='cd ..;clear;pwd;ls -alFh --group-directories-first'
(the name of the alias is u, go to the previous directory, clear the screen, print the working directory, list all files in the directory and group directories first) 

alias d='cd -;clear;pwd;ls -alFh --group-directories-first'
(the name of the alias is d, go to the last directory you were in, clear the screen, print the working directory, list all files in the directory and group directories first) 

alias ll='ls -alFh --group-directories-first'
(the name of the alias is ll, in the folder you are currently in, list all things in the folder, and group directories first) 


# Reflection 

This was definitely a difficult assignment for me to complete. I have never used ftp, chmod, or md5sum commands before, so that was something new 
that I was learning as I was completing this assignment. I also struggled to move around in ftp as I was connected to eduroam I was getting messages like 
invalid command, illegal PORT command, or unable to build data connection, when trying to navigate through the folders of the nci database. 
After having a full conversation with AI (ChatGPT) about this issue, I was able to download the file in ftp using my phone hotspot. I'm still not quite sure
why this worked, but I think there is something with active versus passive mode and/or Eduroam's firewall. As I live on campus, I never had to deal with connecting 
to the William & Mary VPN as I was doing all of my work on campus, but I struggled with the ftp interface. I also struggled with the workflow between my local computer, 
github, and the supercomputer. At the end I realized that I was working on my local computer, and then I pushed everything to github. I then had to go onto the supercomputer
and realize I had duplicated the files that I downloaded from nci. I ended up just overwriting the files, rerunning the chmod commands to make them readable, and then I 
will need to make another push to github, so that everything is up to date. I don't know if I would necessarly change anything, but there were many hard parts to this assignment. 
I also had many troubleshooting steps but hopefully I got everything to work. 
