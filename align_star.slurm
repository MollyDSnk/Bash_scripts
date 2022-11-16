#!/bin/bash


#SBATCH --job-name=align_script         #job name after submission
#SBATCH -p Orion                        #partition being used
#SBATCH -N 1                            #number of nodes to use
#SBATCH --ntasks-per-node=8             #max number of tasks per node
#SBATCH --mem=60gb                      #memory required per node
#SBATCH -t 0-50:00                      #time (D-HH:MM)
#SBATCH -o align_star.%j.out            #standard output file
#SBATCH -e align_star.%j.err            #standard error file
#SBATCH --mail-type=END,FAIL            #Notifications for job complete/failure
#SBATCH --mail-user=mdavi258@uncc.edu   #Send to user email
#SBATCH --array=3-3 


#setting up where to grab files from
file=$(sed -n -e "${SLURM_ARRAY_TASK_ID}p"  /nobackup/tomato_genome/filepairs.txt)

#begin alignment
echo "Beginning Alignment"

cd /nobackup/tomato_genome/genome/ColHi-Tam/alignment/STAR_align
module load star

#usage-reference included
STAR --runThreadN 8 --runMode alignReads --genomeDir \
/nobackup/tomato_genome/S_lycopersicum_chromosomes.4.00.fa --readFilesIn \
/nobackup/tomato_genome/genome/ColHi-Tam/trim/${file}-R1_paired.fq \
/nobackup/tomato_genome/genome/ColHi-Tam/trim/${file}-R2_paired.fq --outSAMtype BAM SortedByCoordinate

echo "Alignment Finished"
