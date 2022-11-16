#!/bin/bash


#SBATCH --job-name=assembly             #job name after submission
#SBATCH -p Draco                        #partition being used
#SBATCH -N 1                            #number of nodes to use
#SBATCH --ntasks-per-node=8             #max number of tasks per node
#SBATCH --mem=900gb                     #memory required per node
#SBATCH -t 14-00:00                      #time (D-HH:MM)
#SBATCH -o spades_assembly.%j.out       #standard output file
#SBATCH -e spades_assembly.%j.err       #standard error file
#SBATCH --mail-type=END,FAIL            #Notifications for job complete/failure
#SBATCH --mail-user=mdavi258@uncc.edu   #Send to user email
#SBATCH --array=1-1


#setting up where to grab files from
file=$(sed -n -e "${SLURM_ARRAY_TASK_ID}p"  /nobackup/tomato_genome/filepairs.txt)

#begin alignment
echo "Beginning Assembly"

cd /nobackup/tomato_genome/genome/ColHi-Tam/assembly/spades_tom
module load spades
 
#usage
spades.py --careful -o ${file}_spades \
-1 /nobackup/tomato_genome/genome/ColHi-Tam/trim/${file}-R1_paired.fq \
-2 /nobackup/tomato_genome/genome/ColHi-Tam/trim/${file}-R2_paired.fq 

echo "Assembly Finished"
