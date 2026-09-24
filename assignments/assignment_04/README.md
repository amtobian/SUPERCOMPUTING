Allie Tobian 
Assignment 4 
9/22/26

# gh 

the gh "tarball" has been unpacked in /sciclone/home/amtobian/programs 
the permissions have been updated to --rwxr-xr-- so that the group can read and execute, and anytone can read. 
the bash script is saved in /sciclone/home/amtobian/programs/install_gh.sh
the installed gh file is in /sciclone/home/amtobian/programs/gh_2.74.2_linux_amd64
there is another version of gh that was installed earlier this semester (gh_2.74.0_linux_amd64)

# seqtk

the installation script for seqtk is saved in /sciclone/home/amtobian/programs/install_seqtk.sh
the permissions have been updated to -rwxr-xr-- so that the group can read and execute, and anyone can read 
the summarize_fasta.sh script is saved in /sciclone/home/amtobian/SUPERCOMPUTING/assignments/assignment_04

# task 9
for file in data/*.fasta
do 
bash summarize_fasta.sh "$file"
done

# reflection 

I struggled with this assignment, like I have with the other assignments. I struggled with the push to GitHub, I had a large file in the repo that I kept forgetting about -- 
I spent a lot of time fighting GitHub using ChatGPT commands to try and just be able to push it without messing up things. 
At one point I even decided that it was better to just delete the repo and redownload but I somehow messed that up and it didn't work so I continued to fight GitHub.
I started semi blindly taking instructions from ChatGPT to try and solve this, using some github commands we have not used in class, 
and that I did not fully understand. However I was able to get it to work and restart the upload to github. In addition to this challenge, 
I also struggled to learn the seqtk language. I underestimated the time that it would take me to complete this assignment. 
Even though I found this assignment to be longer that I was expecting and even with the GitHub issues, I feel like I learned 
a lot from this assignment. I have grown much more comfortable using my terminal, command lines, and the supercomputer. 
New things that I have learned specifically from this assignment is that I have learned some shell script, the seqtk language, and github specific language (see above). 
I believe that $PATH is used to be able to control your location, but the location is variable from one computer to the next, 
as well as when you are running a script or a program multiple times but in different locations on the same computer. It is very 
usefull as it is NOT a static variable. 
