#!/bin/env bash

# This is a shell script for running nf-core/rnaseq pipeline version 3.4
# on RNA-Seq data from NSF award 1939255.
#
# For project info, see: https://www.nsf.gov/awardsearch/showAward?AWD_ID=1939255
#
# For nf-core/rnaseq v. 3.4 documentation, see: https://nf-co.re/rnaseq/3.4/usage.
#
# How to run this script on UNCC high-performance computing infrastructure:
#
#
# step 1 - Log into the UNCC virtual private network (using Cisco AnyConnect)
#          and then, log into one of the head nodes (10.16.115.244, 10.16.115.245)

#          Configure your environment. Add the following to your .bash_profile
#          account configuration file in your home directory:
#
#          # make sure nextflow uses slurm always
#          export NXF_EXECUTOR=slurm
#
#          # save singularity containers in a shared location
#          export NXF_SINGULARITY_CACHEDIR=/nobackup/tomato_genome/scripts/nxf_singularity_cachedir
#
#          # tell nextflow to not access the internet when running
#          export NXF_OFFLINE='TRUE'
#
#          # control java heap size for nextflow
#          export NXF_OPTS="-Xms1g -Xmx4g" 
#
#
# step 2 - On the login (head) node, start a long-lived shell program so that
#          if you're disconnected from the node, you can resume your session later.
#
#          Use tmux for this. To start a new tmux session, enter something like:
#
#              tmux new -s base
#
#          This command starts a new session and names it "base". If you get
#          disconnected, log back into the same login (head) node, and enter:
#
#            : tmux attach-session -t base 
#  
# step 3 - Launch an interactive session on a "node" with plenty of memory and time.
#          You'll use this session to actually launch and run the nf-core rnaseq nextflow
#          pipeline.
#
#          For example, the following command (srun) starts an interactive session (--pty bash)
#          on the UNCC Andromeda cluster (--partition) with 5 cpus and 12 Gb memory per CPU, lasting
#          60 hours:
# 
#               srun --partition Andromeda
#                    --cpus-per-task 16
#                    --mem-per-cpu 12000
#                    --time 60:00:00
#                    --pty bash
#
#           After entering the above, you should see something like the following printed to the
#           the terminal. This shows that your interactive session has started.
#
#               srun: job 1446946 queued and waiting for resources
#               srun: job 1446946 has been allocated resources
#        
# step 4 - In the interactive session (started in Step 3), activate the nf-core virtual
#          environment. 
#
#          At UNCC, enter:
#
#              module load nf-core
#
#          If it works properly, you'll see your command prompt change to "nf-core".
#
# step 5 - Make sure there's a local copy of nf-core/rnaseq v. 3.4 code somewhere your user can
#          access it. For this, you can add a symbolic link to the directory where you'll run
#          nextflow. You won't make any changes to this code, but nextflow needs to be able to
#          access it when running.
#
#          You can also deploy a local copy of nf-core/rnaseq version 3.4. To do this, log into
#          a head node, start the nf-core virtual environment (as in step 4), and enter:
#
#               nf-core download rnaseq -r 3.4
#
#          This will start an interactive download session. When asked whether to download
#          software container images, choose option "singularity," which is not the default.
#          Note that this ensures all images will be available when you run nextflow later.
#          Also, the environment variable NXF_SINGULARITY_CACHEDIR configured in step one
#          controls where the images will be stored. 
# 
# step 6 - Assemble the files and/or symbolic links to resources needed to run rnaseq pipeline.
# 
#          For example, let's say your rnaseq fastq files are in /nobackup/tomato_genome/alt_splicing/SRP252265.
#          To run nf-core/rnaseq v. 3.4, move into your fastq directory and create symbolics links to
#          required resources by entering:
#
#          ln -s /nobackup/tomato_genome/scripts/flavonoid-rnaseq/ExternalDataSets/tomato.config .
#          ln -s /nobackup/tomato_genome/scripts/flavonoid-rnaseq/src/doIt.sh .
#          ln -s /nobackup/tomato_genome/alt_splicing/S_lycopersicum_Jun_2022.fa .
#          ln -s /nobackup/tomato_genome/scripts/flavonoid-rnaseq/ExternalDataSets/S_lycopersicum_Jun_2022.bed .
#          ln -s /nobackup/tomato_genome/scripts/flavonoid-rnaseq/ExternalDataSets/S_lycopersicum_Jun_2022.gtf .
#          ln -s /nobackup/tomato_genome/ExternalDataSets/S_lycopersicum_Jun_2022.gtf .
#          ln -s /nobackup/tomato_genome/scripts/nf-core-rnaseq-3.4 .
#          ln -s /nobackup/tomato_genome/scripts/flavonoid-rnaseq/ExternalDataSets/SRP328042.csv .
#              
# step 7 - Start nextflow in your interactive session. In your interactive session started in step 3,
#          run the doIt.sh script, passing the 5 arguments described below.
#
#          For example, enter:
#
#          ./doIt.sh SRP328042.csv S_lycopersicum_Jun_2022.fa S_lycopersicum_Jun_2022.gtf \
#               S_lycopersicum_Jun_2022.bed tomato.config 1> out.txt 2> err.txt
#        
#          If all goes well, a nextflow sessions will launch. It will print update to the screen,
#          and any text printed to stdout will be saved in "out.txt" and any error messages printed
#          to stderr will be saved in err.txt.
#
# 
SAMPLESHEET=$1
GENOMEFASTA=$2
GTF=$3
GENEBED=$4
CONFIG=$5

MS="Requires sample sheet, reference genome sequence, annotations GTF, annotations BED, and configuration file"
EX="Example: ./doIt.sh samples.csv S_lycopersicum_Sep_2019.fa S_lycopersicum_Sep_2019.gtf S_lycopersicum_Sep_2019.bed 
tomato.config"

if [[ -z "$SAMPLESHEET" ]]; then
    echo "$MS" 1>&2
    echo "$EX" 1>&2
    exit 1
fi
if [[ -z "$GENOMEFASTA" ]]; then
    echo "$MS" 1>&2
    echo "$EX" 1>&2
    exit 1
fi
if [[ -z "$GTF" ]]; then
    echo "$MS" 1>&2
    echo "$EX" 1>&2
    exit 1
fi
if [[ -z "$GENEBED" ]]; then
    echo "$MS" 1>&2
    echo "$EX" 1>&2
    exit 1
fi
if [[ -z "$CONFIG" ]]; then
    echo "$MS" 1>&2
    echo "$EX" 1>&2
    exit 1
fi

# ran it first with star/salmon --aligner option
# then ran it with hisat as shown below
# this was to allow comparing aligner performance
# project-wide, however, we decided to use
# star/salmon alignment
module load nf-core
nextflow run nf-core-rnaseq-3.4/workflow \
         -resume \
         -profile singularity \
         -c $CONFIG \
         --aligner star_salmon \
         --save_trimmed \
         --fasta $GENOMEFASTA \
         --input $SAMPLESHEET \
         --gtf $GTF \
         --gene_bed $GENEBED \
         --skip_biotype_qc \
         --skip_markduplicates \
         --skip_bigwig \
         --skip_stringtie \
         --skip_qualimap \
         --skip_fastqc \
         --skip_custom_dumpsoftwareversions 







