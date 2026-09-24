Allie Tobian 

9/15/2026

Assignment 3



Download the file
# In Local Computer 
cd Downloads
mv GCF_000001735.4_TAIR10.1_genomic.fna.gz ~/SUPERCOMPUTING/assignments/assignment_03/data
cd 
cd ~/SUPERCOMPUTING/assignments/assignment_03

gunzip GCF_000001735.4_TAIR10.1_genomic.fna.gz


#How many sequences are in the FASTA file? (answer=7)
grep -c ">" GCF_000001735.4_TAIR10.1_genomic.fna
7

#What is the total number of nucleotides (not including header lines or newlines)? (answer=119,668,634)
 grep -v "^>" GCF_000001735.4_TAIR10.1_genomic.fna | tr -d '\r\n' | wc -m
119668634

#How many total lines are in the file? (answer=14)
 cat GCF_000001735.4_TAIR10.1_genomic.fna | wc -l
14

#How many header lines contain the word "mitochondrion"? (answer=1)
 grep -c "mitochondrion" GCF_000001735.4_TAIR10.1_genomic.fna
1

#How many header lines contain the word "chromosome"? (answer=5)
 grep -c "chromosome" GCF_000001735.4_TAIR10.1_genomic.fna
5

#How many nucleotides are in each of the first 3 chromosome sequences? (answer=30,427,672   19,698,290  23,459,831)
grep -v "^>" GCF_000001735.4_TAIR10.1_genomic.fna | head -n 3 | awk '{print length($0)}'
30427671
19698289
23459830


#How many nucleotides are in the sequence for 'chromosome 5'? (answer=26,975,503)
 grep -A 1 "chromosome 5" GCF_000001735.4_TAIR10.1_genomic.fna | tail -1 | tr -d '\n' | wc -m
26975502

#How many sequences contain "AAAAAAAAAAAAAAAA"? (answer=1)
grep -c "AAAAAAAAAAAAAAAA" GCF_000001735.4_TAIR10.1_genomic.fna
1

#If you were to sort the sequences alphabetically, which sequence (header) would be first in that list? (answer=>NC_000932.1...)
 sort GCF_000001735.4_TAIR10.1_genomic.fna | head -1
>NC_000932.1 Arabidopsis thaliana chloroplast, complete genome

#How would you make a new tab-separated version of this file, where the first column is the headers and the second column are the associated sequences? (show the command(s))
grep "^>" GCF_000001735.4_TAIR10.1_genomic.fna > headers.txt
grep -v "^>" GCF_000001735.4_TAIR10.1_genomic.fna > sequences.txt
paste headers.txt sequences.txt > new_sequences_file.tsv


# Reflection 
My approach for this assignment was to work slowly and methodically through the assignment. Well obviously, the first step I took in completing this assignment was to download the file, move it to the correct place on my local computer and unzip the file. I was trying to move my file inside assignment_03 into data and wrote the command mv GCF_000001735.4_TAIR10.1_genomic.fna assignment3, I could not go into assignment3 so I had to remove it and download the fna file again, and move it again (hopefully without messing it up). 

I then worked through the questions starting with the easiest ones for me to code, confirming my answer with the answer provided in the instructions. This was my first experience with Unix commands, so I spent some time learning those commands. Once I did the ones that were easier, I started to look up commands so that I could do the harder ones for me. I got semi-frustrated not knowing how to do everything at first, but I was able to work through and get it done. 

This is useful when working with large data sets to be able to describe what you are working with. Summarizing and sorting data are all important skills that provide important information for bioinformatics. The command line coding skills are both incredibly fast and efficient, and knowing how to use them to write, overwrite, or append to a file to save information is incredibly useful. I was writing all of my work for this assignment to the screen, but I could have easily redirected it to be saved to a file that can be accessed later. These skills are incredibly useful for understanding what the computer is doing when it is throwing numbers out of the screen. It is also efficient to use, but also easy to mess something up and get a weird number if you do not know what you are doing. It would be incredibly easy to erase, overwrite, or use the wrong part of your data set when using these tools if you even just mis type a single letter. 

I'm not quite sure how this could be automated, but maybe by creating a summary chart of useful things to know about these sequences could be a way of automation instead of individually checking each line of the file, some of which are quite long. 
