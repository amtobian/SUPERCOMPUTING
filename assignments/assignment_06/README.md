Allie Tobian 
Assignment 6
10/14/2026

This assignment explored running a software, flye three different ways on the same piece of data. 
The three ways that flye was run were a local build, a module install and on conda. 

Task 1 was setting up the assignment for completion my making the folder structure. 

Task 2 involved downloading the raw data. Althogh I downloaded the data directly in my terminal, I saved the commands I used and they are documented in scripts/01_download_data.sh
Although the script is saved inside of the scripts subfolder, the script should be run as bash ./scripts/01_donwload_data.sh

Task 3 was setting up the local build of flye. I used the github instructions to figure out how to do this, and the script to do an manual install of flye is scripts/02_flye_2.9.5_manual_build.sh. Thisshould be run the same way inside of the assignment_06 subfolder/ 

Task 4 set up conda and created an environment to access flye. This is in 02_flye_2.9.5_conda_install.sh. Run the same way inside of assignment_06 subfolder/ 

Task 5 was figuring out how to use flye. 

Task 6 was running flye in all (manual, module, conda) of the ways. The scripts that should work if the hpc does not time out are also in the scripts folder.
All of these scripts look very similar and that is because the goal is for all of the output from all of the scripts to be the same. 

Task 7 was to compare the results. However I couldn't get the scripts to run without the hpc session timing out and quitting on me. I tried I put a lot of effort into this, the hpc didn't like me. 
I really tried my best to do this I couldn't. I even wrote an email to you (Prof. Zahn and Bailey) at 10pm the day before this assignment was due to see if I was doing something wrong.
I thought I could do this but I guess that the hpc just really dosen't like me. 

Task 8 was to build a pipeline to run everything at once. This pipeline runs the scripts that hopefully work in the previous tasks. 
Like I previously stated I wasn't able to get task 7 to work but I included in the pipeline code that would hopefully compare the outputs like task 7 was requesting though I did not check this because I couldn't. 

Task 9 was to see if pipeline worked. I still kept getting timed out. I got really frustrated over this assignment. 

The pipeline should be run out of assignment_06 subfolder inside of the SUPERCOMPUTING repo. 

Task 10 is the one that you are currently reading. If you keep reading below you will see my reflection. 
I got really frustrated with this assignment. I decided not to work on this assignment over fall break. That means my troubleshooting time is now significantly less and I ran into a lot of issues. 
Bash kept disconnecting me from my terminal. I couldn't even do the manual download of flye wihtout it disconnecting. Thinking I might've had an isolated incident I did a good little slurm job to make flye locally and finish building it. But then I kept going and I still had issues after issues after issues. 
I worked on it, I used chatgpt to see if it could help me troubleshoot -- I even learned how to do a screen to see if that would help. 
I emailed you (I know I am repeating myself here), and then I decided I tried to troubleshoot it some more. 
I still couldn't get it. I decided that I needed to sleep and that I really wasn't going to get anywhere with this assignment -- even though I was supposed to. I figured 
I had learned something from this assignment even though I hadn't fully finished it and I should finish what I can (write this reflection) and move on. 
Maybe the hpc will like me more tomorrow? Or maybe I can use slurm to make the code work?
And as for the different methods, the module method was definitely convenient as there was less set up to do. 
Next time I would probably go for the module setup first if that is availble, if not then maybe local build. 
I don't really understand what conda is doing and the activate/deactivate steps but once I understand more of what is happening it would be a more enticing option. 

###UPDATE
After taking a break thinking about this assignment, I decided I should see what would happen if I use a little slurm action.
Well the first time I ran it I had a failure after seven minuites. so then i debugged and asked chatgpt what was wrong and then i decided to make very few changes and run it again. 
So I ran it again and I got stuff that looked right! And it fully ran before I was kicked out! I view this as a success :)))))
But then I looked at my outputs to visually check and realized that I didn't delete all my extra files/directories inside fo assemblies because I didn't know what they were named. 
So then I added to my scripts to fully remove those things and I hope that script works now because I'm not checking it again -- it is way to late for that it it is past my self-imposed bedtime. 

So there you have it folks, this should work when I tested it via copying and pasting my pipeline script into a new script with a slurm header and running it for 15 mins. 
I do know just as a warning that the script is a little finicky and you have to be careful with it like if you already have flye installed it won't work but I'm not sure how to solve those problems right now. That should be the next lecture (or the next thing I look up when I am not really tired!!!)

For Task 7 I got the same output with my loop for all 3 things which is what i wanted. When I run it all on the same data I should get the same thing out :)
I make the assumption that Task 8 and Task 9 also work. This was a very hard and frustrating assignment but it is done!!!!!
