#!/bin/bash


#SBATCH --job-name=fastqc               #job name after submission
#SBATCH -p Orion                        #partition being used
#SBATCH -N 1                            #number of nodes to use
#SBATCH --ntasks-per-node=8             #max number of tasks per node
#SBATCH --mem=60gb                      #memory required per node
#SBATCH -t 0-50:00                      #time (D-HH:MM)
#SBATCH -o fastqc.%j.out                #standard output file
#SBATCH -e fastqc.%j.err                #standard error file
#SBATCH --mail-type=END,FAIL            #Notifications for job complete/failure
#SBATCH --mail-user=mdavi258@uncc.edu   #Send to user email


module load fastqc

for i in /nobackup/tomato_genome/30-804059537-KP/*.fastq.gz
do
  	fastqc -o /nobackup/tomato_genome/30-804059537-KP/fastQC_dataQuality $i
done
