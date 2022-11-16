#!/bin/bash

#SBATCH --time=296:30:00

# Request 1 processor in 1 node
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=12

# Request 7600 megabytes memory per processor.  ( 48 usable CPUs)
#SBATCH --mem=401gb
####### UNABLE TO CONVERT (please review): #PBS -j oe
#SBATCH --job-name=bbbblast-SR
#SBATCH --partition=Draco
##SBATCH --array=1-4
#SBATCH --output=rrr-%x.%j.out
#SBATCH --error=rrr-%x.%j.err

umask 007
set -eu

#file=$(sed -n -e "${SLURM_ARRAY_TASK_ID}p" /nobackup/tomato_genome/rnaseq-phase1/trinity/names.txt)
#dir=$(sed -n -e "${PBS_ARRAYID}p" /lustre/groups/lorainelab/data/illumina/sweet_potato/filtered/dir.txt)

echo "Launching BLAST alignments"

#module load java8 
module load blast
#module load trinity
#module load bowtie


cd /nobackup/tomato_genome/alt_splicing/SR-proteins

#makeblastdb -in /projects/tomato_genome/db/SL5/SL5.cds.fa -dbtype nucl
#makeblastdb -in /projects/tomato_genome/db/SL5/SL5.pep.fa -dbtype prot 


blastn -db /projects/tomato_genome/db/SL5/SL5.cds.fa \
-out ./blastn-SR17cds-vs-SL5genes.txt \
-query ./SRgenes-arabid.fna \
-num_threads 12 \
-evalue 1e-10 \
-soft_masking true  -outfmt 6 

blastn -db ./SRgenes-arabid.fna \
 -out ./blastn-SL5genes-vs-SR17cds.txt \
 -query /projects/tomato_genome/db/SL5/SL5.cds.fa \
 -num_threads 12 \
 -evalue 1e-10 \
-soft_masking true  -outfmt 6

blastx -db /projects/tomato_genome/db/SL5/SL5.pep.fa \
 -out ./blastx-SR17cds-vs-SL5pep.txt \
 -query ./SRgenes-arabid.fna \
 -num_threads 12 \
 -evalue 1e-10 \
 -soft_masking true  -outfmt 6

tblastn -db ./SRgenes-arabid.fna \
 -out ./tblastn-SL5pep-vs-SR17cds.txt \
 -query /projects/tomato_genome/db/SL5/SL5.pep.fa \
 -num_threads 12 \
 -evalue 1e-10 \
 -soft_masking true  -outfmt 6


blastp -db /projects/tomato_genome/db/SL5/SL5.pep.fa \
 -out ./blastp-SR17pep-vs-SL5pep.txt \
 -query ./SRproteins.faa \
 -num_threads 12 \
 -evalue 1e-10 \
 -soft_masking true  -outfmt 6

blastp -db ./SRproteins.faa  \
 -out ./blastp-SL5pep-vs-SR17pep.txt \
 -query /projects/tomato_genome/db/SL5/SL5.pep.fa \
 -num_threads 12 \
 -evalue 1e-10 \
 -soft_masking true  -outfmt 6
                                                                                                      blastx -db 
./SRproteins.faa \
 -out ./blastx-SL5cds-vs-SR17pep.txt \
 -query /projects/tomato_genome/db/SL5/SL5.cds.fa \
 -num_threads 12 \
 -evalue 1e-10 \
 -soft_masking true  -outfmt 6

tblastn -db /projects/tomato_genome/db/SL5/SL5.cds.fa \
 -out ./tblastn-SR17pep-vs-SL5cds.txt \
 -query ./SRproteins.faa \
 -num_threads 12 \
 -evalue 1e-10 \
 -soft_masking true  -outfmt 6





echo "Finished"
