#! /bin/bash

#SBATCH --job-name=prefetch_SRR
#SBATCH --partition=Orion
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --mem=4gb
#SBATCH --output=%x_%j.out
#SBATCH --time=24:00:00

cd /nobackup/tomato_genome/alt_splicing/SRP371294/
module load sra-tools/2.11.0
vdb-config --interactive

files=(
       	SRR18832835
        SRR18832836
        SRR18832837
        SRR18832838
        SRR18832839
        SRR18832840
)

for f in "${files[@]}"; do echo $f; prefetch $f;  done
