#! /bin/bash

#SBATCH --job-name=fastqdump_SRR
#SBATCH --partition=Orion
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --mem=40gb
#SBATCH --output=%x_%j.out
#SBATCH --time=24:00:00
#SBATCH --array=1-6

#setting up where to grab files from
file=$(sed -n -e "${SLURM_ARRAY_TASK_ID}p"  /nobackup/tomato_genome/alt_splicing/SRP371294/Sra_ids.txt)


cd /nobackup/tomato_genome/alt_splicing/SRP371294
module load sra-tools/2.11.0

echo "Starting faster-qdump on $file";

cd /nobackup/tomato_genome/alt_splicing/SRP371294/$file

fasterq-dump ${file}.sra

perl /projects/tomato_genome/scripts/validateHiseqPairs.pl ${file}_1.fastq ${file}_2.fastq

cp ${file}_1.fastq /nobackup/tomato_genome/alt_splicing/SRP371294/${file}_1.fastq
cp ${file}_2.fastq /nobackup/tomato_genome/alt_splicing/SRP371294/${file}_2.fastq 

echo "finished"

