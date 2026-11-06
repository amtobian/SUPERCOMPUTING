Navigate to the SRA in your browser
I want you to find at least 10, but no more than 20 accessions
Shotgun metagenome data (random library selection, not amplicon)
Illumina sequences, not PacBio or ONT
Send your selected results to the "Run Selector" and then download the Metadata

Upload this csv file to the HPC (~/SUPERCOMPUTING/assignments/assignment_7/data/) using FileZilla or FTP
Write a script that loops through the first column ("Run") and uses `fasterq-dump` to download the raw data from those accessions
Also, in the same script, use the NCBI `datasets` command-line program to download the reference genome for Canis familiaris (reference genome only!)

Note: This should be a standalone script that your SLURM job will call. We try to keep things "modular" when possible. It would work to have the entirety of this assignment be hard-coded into the SLURM script, but that can get messy.

Note: DOCUMENT your search string and where your metadata file is, and everything!

Note: Your script should handle everything including extracting the dog genome and moving files to where they belong.
_______________________________________________________________________
Task 3. Clean up raw reads
I recommend using fastp like before. Put your trimmed and filtered reads in the `./data/clean/` directory. Document all the QC parameters you used. If you use default parameters, document that.

I'd make this a separate script as well. And I'd do it in a loop.

Note: fastp requires 4 filenames for each command (in1, in2, out1, out2). You will need to use the input filenames (the raw reads fwd and rev files) to build these. And you'll need to do that "building" INSIDE of your loop! (you've done this before)
_______________________________________________________________________
Task 4. Map clean reads to dog genome
In a third script, use `bbmap.sh` to map your quality filtered reads against the dog reference genome. Use a minimum alignment identity of 95%. Do this in a loop for all your samples.
Be aware of the memory requirements here. You may need to increase the available memory using the -Xmx flag.
This flag specifies the maximum amount of memory the JVM can allocate to BBMap. For example, to set the maximum memory to 16GB, you would use -Xmx16g
How much memory will you request from the bora server? How much time?
_______________________________________________________________________
Task 5. Extract reads that matched dog genome
Continuing the third script, you will use samtools to extract any reads that had significant positive matches to the dog reference genome. This program is for working with sam/bam files and using all those "flags" and alignment positions we saw in the previous assignment.

This is a quick process once you have it working.

Note: `-F 4` is the "flag" to exclude unmapped reads when using `samtools view` (so it keeps mapped reads)
_______________________________________________________________________
Task 6. Submit your job to SLURM

Okay, you have 3 scripts to run (in order). Do what you need to do to test them out (using tiny files) to make sure everything is working. Then build out a SLURM job script that submits them to the server to run. Store this script as `./assignment_7_pipeline.slurm`

Be sure to direct the stdout and stderr to your `/ABS/PATH.../assignment_7/output (or log/)` directory.
_______________________________________________________________________
Task 7. Inspect your stdout and stderr
Once your jobs have started running (set an email alert in your slurm header if you want), you can see the progress by looking in the .out and .err files. If things don't work out, these will have the messages that can help you track down what went wrong. Most likely, if there's an error it's because of a bungled filepath.
_______________________________________________________________________
Task 8. Inspect your results
Did you find any dog DNA in your metagenomic files? I've found it in fairly high abundance in samples presumably from coral reefs! It's a common contaminant in labs where researchers.... have dogs ;)
Create a table (manually, or via script) similar to the one below that shows each of your samples, the number of QC reads, and the number of reads that mapped to the dog genome. Add this to your README.md file.

Task 9. Document Everything in README.md
README.md should use descriptions to explain what you did, where those files are, etc.
It should also tell a future user how to run the pipeline, what it will do, etc.
Add a reflection that addresses:
Any challenges you had to overcome
New things you learned
Style it up as a nice markdown document so it looks good on GitHub
