#!/bin/bash

#SBATCH --time=296:30:00

# Request 1 processor in 1 node
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=24

# Request 7600 megabytes memory per processor.  ( 48 usable CPUs)
#SBATCH --mem=401gb
####### UNABLE TO CONVERT (please review): #PBS -j oe
#SBATCH --job-name=nnnnfcore-splice
#SBATCH --partition=Draco
##SBATCH --array=1-4
#SBATCH --output=rrr-%x.%j.out
#SBATCH --error=rrr-%x.%j.err

umask 007
set -eu

#file=$(sed -n -e "${SLURM_ARRAY_TASK_ID}p" /nobackup/tomato_genome/rnaseq-phase1/trinity/names.txt)
#dir=$(sed -n -e "${PBS_ARRAYID}p" /lustre/groups/lorainelab/data/illumina/sweet_potato/filtered/dir.txt)

echo "Launching Nextflow NF-Core"

#module load java8 
module load singularity
module load nf-core

##Always use slurm
export NXF_EXECUTOR=slurm
##Save Singularity containers in home dir
export NXF_SINGULARITY_CAHCEDIR="$HOME/nxf"
## Tell nextflow not to use internet
export NXF_OFFLINE='TRUE'
## Control Java Heap Size
export NXF_OPTS="-Xms2g -Xmx8g"

###Change????
cd /nobackup/tomato_genome/alt_splicing

#makeblastdb -in  /projects/tomato_genome/db/reference-4.0/ITAG4.0_cDNA.fasta -dbtype nucl

#nextflow run nf-core/rnaseq –profile ../../test,singularity

#/nobackup/tomato_genome/nfcore_rnaseq/tomato.config



###Change????
nextflow run  /nobackup/tomato_genome/nfcore_rnaseq/nf-core-rnaseq-3.4/workflow \
 -resume \
 -profile singularity \
 --fasta  /nobackup/tomato_genome/nfcore_rnaseq/S_lycopersicum_Sep_2019.fa \
 --input samples.csv \
 --gtf  /nobackup/tomato_genome/nfcore_rnaseq//S_lycopersicum_Sep_2019.gtf \
 --gene_bed  /nobackup/tomato_genome/nfcore_rnaseq//S_lycopersicum_Sep_2019.bed \
 --skip_biotype_qc



echo "fin"

