#!/bin/bash


#SBATCH --job-name=align_script         #job name after submission
#SBATCH -p Orion                        #partition being used
#SBATCH -N 1                            #number of nodes to use
#SBATCH --ntasks-per-node=8             #max number of tasks per node
#SBATCH --mem=60gb                      #memory required per node
#SBATCH -t 0-50:00                      #time (D-HH:MM)
#SBATCH -o align_hisat.%j.out           #standard output file
#SBATCH -e align_hisat.%j.err           #standard error file
#SBATCH --mail-type=END,FAIL            #Notifications for job complete/failure
#SBATCH --mail-user=mdavi258@uncc.edu   #Send to user email
#SBATCH --array=3-3


#setting up where to grab files from
file=$(sed -n -e "${SLURM_ARRAY_TASK_ID}p"  /nobackup/tomato_genome/filepairs.txt)

#begin alignment
echo "Beginning Alignment"

cd /nobackup/tomato_genome/genome/ColHi-Tam/alignment/HISAT2_align
module load hisat2 

#reference
hisat2-build /nobackup/tomato_genome/S_lycopersicum_chromosomes.4.00.fa reference 

#usage
hisat2 -x reference -1 /nobackup/tomato_genome/genome/ColHi-Tam/trim/${file}-R1_paired.fq \
-2 /nobackup/tomato_genome/genome/ColHi-Tam/trim/${file}-R2_paired.fq -S ${file}_alignment.sam

echo "Alignment Finished"

#use samtools to convert sam to bam and sort 
module load samtools
samtools view -b ${file}_alignment.sam > ${file}.bam
samtools sort ${file}.bam -o ${file}_sort.bam 
samtools index ${file}_sort.bam

#use bcftools to convert bam to vcf files to then view in IGB/IGV 
bcftools mpileup -f /nobackup/tomato_genome/S_lycopersicum_chromosomes.4.00.fa \
${file}_sort.bam | bcftools call -c -v > ${file}.vcf

echo "VCF created"
echo "Ending Script"
