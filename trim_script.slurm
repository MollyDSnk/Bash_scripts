#!/bin/bash


#SBATCH --job-name=trim_script          #job name after submission
#SBATCH -p Orion                        #partition being used
#SBATCH -N 1                            #number of nodes to use
#SBATCH --ntasks-per-node=8             #max number of tasks per node
#SBATCH --mem=60gb                      #memory required per node
#SBATCH -t 0-10:00                      #time (D-HH:MM)
#SBATCH -o trim_tomato.%j.out           #standard output file
#SBATCH -e trim_tomato.%j.err           #standard error file
#SBATCH --mail-type=END,FAIL            #Notifications for job complete/failure
#SBATCH --mail-user=mdavi258@uncc.edu   #Send to user email
#SBATCH --array=1-3 

#setting up where to grab files from
file=$(sed -n -e "${SLURM_ARRAY_TASK_ID}p"   /projects/tomato_genome/genome/30-693209853/00_fastq/filepairs.txt)

#begin trimming
echo "Beginning Trim"

cd /nobackup/tomato_genome/genome/ColHi-Tam/trim
module load trimmomatic  
java -jar /apps/pkg/trimmomatic/0.39/trimmomatic-0.39.jar \
PE -summary summary-${file}.txt -validatePairs \
/users/mdavi258/tomato_genome_molly/copied_genome_files/copy_${file}_R1_001.fastq.gz \
/users/mdavi258/tomato_genome_molly/copied_genome_files/copy_${file}_R2_001.fastq.gz \
${file}-R1_paired.fq  ${file}-R1_unpaired.fq ${file}-R2_paired.fq  ${file}-R2_unpaired.fq \
ILLUMINACLIP:/apps/pkg/trimmomatic/0.39/adapters/TruSeq2-PE.fa:2:30:10 TRAILING:30 SLIDINGWINDOW:4:20 MINLEN:50 CROP:244

echo "Trimming Finished"

#run fastqc to analyze the quality of the trims

#cd /nobackup/tomato_genome/genome/ColHi-Tam/trim

module load fastqc
fastqc *.fq

