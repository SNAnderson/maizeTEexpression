#PBS -l walltime=18:00:00,nodes=1:ppn=6,mem=40gb
#PBS -o TEbatch2.o
#PBS -e TEbatch2.e
#PBS -V
#PBS -N sra
#PBS -r n
#PBS -m abe

# qsub -t 1-71 -v LIST=samples.txt  te_expression_from_SRA.sh

SAMPLE="$(/bin/sed -n ${PBS_ARRAYID}p ${LIST} | cut -f 1)"
NICKNAME="$(/bin/sed -n ${PBS_ARRAYID}p ${LIST} | cut -f 2)"

module load sratoolkit

fastq-dump --split-files ${SAMPLE}

module load cutadapt/1.8.1
cutadapt  -a AGATCGGAAGAGCACACGTCTGAACTCCAGTCAC -A AGATCGGAAGAGCGTCGTGTAGGGAAAGAGTGTAGATCTCGGTGGTCGCCGTATCATT -f fastq -m 30 -q 10 --quality-base=33 -o ${SAMPLE}_1.trimmed.fastq -p ${SAMPLE}_2.trimmed.fastq ${SAMPLE}_1.fastq ${SAMPLE}_2.fastq

module load bowtie2/2.2.4
module load tophat/2.0.13

if [ ! -d ${SAMPLE} ]; then
    mkdir ${SAMPLE}
fi

tophat2 -p 6 -g 20 -i 5 -I 60000 --no-sort-bam -o ${SAMPLE} Zea_mays.AGPv4.dna.toplevel ${SAMPLE}_1.trimmed.fastq ${SAMPLE}_2.trimmed.fastq

cp ${SAMPLE}/accepted_hits.bam ${SAMPLE}.bam

module load samtools/1.9
module load bamtools/20120608
module load python/3.6.3
module load htseq/0.5.3


samtools sort -n ${SAMPLE}.bam | samtools view - | perl convert_sam_to_all_NH1_v2.pl - | python -m HTSeq.scripts.count -s no -t all -i ID -m union -a 0 -o ${SAMPLE}.edited.sam - B73.structuralTEv2.1.07.2019.filteredTE.subtractexon.plusgenes.chr.sort.gff3 > counts_intermediate_${SAMPLE}.txt

perl te_family_mapping_ver6.pl ${SAMPLE}.edited.sam ${NICKNAME} 
