#!/bin/bash


#SBATCH --job-name=validate_script      #job name after submission
#SBATCH -p Orion                        #partition being used
#SBATCH -N 1                            #number of nodes to use
#SBATCH --ntasks-per-node=8             #max number of tasks per node
#SBATCH --mem=60gb                      #memory required per node
#SBATCH -t 0-50:00                      #time (D-HH:MM)
#SBATCH -o validate.%j.out              #standard output file
#SBATCH -e validate.%j.err              #standard error file
#SBATCH --mail-type=END,FAIL            #Notifications for job complete/failure
#SBATCH --mail-user=mdavi258@uncc.edu   #Send to user email
#SBATCH --array=1-48


#setting up where to grab files from
file=$(sed -n -e "${SLURM_ARRAY_TASK_ID}p"  /nobackup/tomato_genome/alt_splicing/runlistSRP252265.txt)

#The command to validate each pair:
cd /nobackup/tomato_genome/alt_splicing/SRP252265

perl /projects/tomato_genome/scripts/validateHiseqPairs.pl ${file}_1.fastq ${file}_2.fastq


echo "Done"

