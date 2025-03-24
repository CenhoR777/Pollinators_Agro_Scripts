#! /bin/bash

# Script that runs maps multiple sequences to the same referencewith Bowtie and Samtools.
# Assumes that each sample has two paired-end files (for now).

options=':i:s:o:n:x:h'
while getopts $options opt; do
    case ${opt} in
        i) 
            input_dir=${OPTARG}
            ;;
        s) 
            samplelist=${OPTARG}
            ;;
        o)
            output_dir=${OPTARG}
            ;;
        n)
            index=${OPTARG}
            ;;
        x)
            arguments=${OPTARG}
            ;;
        h) 
            # Display Help
           echo
           echo "This script wraps BWA2-MEM and Samtools and does the following:"
           echo "   - map reads against a reference (BWA2-MEM)"
           echo "   - convert BWA output directly to BAM (Samtools)"
           echo "   - sort and index BAM files (Samtools)"
           echo "   - quality checks with Qualimap and MultiQC"
           echo
           echo "Assumes that each sample has two paired-end files."
           echo "Assumes that the different paired-end files have the suffixes 'R1_.1.f*q.gz' and 'R2_.2.f*q.gz' (as outputted by process_radtags)."
           echo
           echo "Syntax: bash bowtieRun_v2.sh [-i INPUT_DIRECTORY] [-s TXT_FILE] [-o OUTPUT_DIRECTORY] [-n /PATH/PREFIX] [-x 'ARGUMENTS']"
           echo
           echo "Mandatory arguments:" 
           echo "-i     Path to directory where the input files are located."
           echo "-s     Text file containing names of the samples, one per line."
           echo "-o     Path to directory where output files should be written."
           echo "-n     Path to index location and prefix used when creating index [/PATH/PREFIX]"
           echo "-x     Arguments to be passed to BWA. Example: -x '-t 100'"
           echo
            exit 0
            ;;
        :)
            echo "Option -${OPTARG} requires an argument."
            exit 1
            ;;
        \?)
            echo "Invalid option: -${OPTARG}." 
            exit 1
            ;;
    esac
done

# mandatory arguments
if [ ! "$input_dir" ] || [ ! "$samplelist" ] || [ ! "$output_dir" ] || [ ! "$index" ]; then
  echo "Arguments -i, -s, -o, -n must be provided."
  exit 1
fi


getDirs() #Defines and creates directories
{
    input_dir=$(realpath $input_dir)
    output_dir=$(realpath $output_dir)

    samplelist=$(realpath $samplelist)

}

bwa_run_paired_end() # Runs BWA for single-end input and converts output into BAM with Samtools
{
    echo
    echo -e "\033[1mMapping sample $sample (${n}/${n_samples}) to reference genome: $(date +"%Y-%m-%d, %Hh%Mm%Ss")\033[0m"; echo 
        
    bwa-mem2 mem \
    $arguments \
    ${index} \
    ${input_dir}/${sample}*R1_.1.f*q.gz \
    ${input_dir}/${sample}*R2_.2.f*q.gz \
    > ${output_dir}/${sample}.bam

    #2052 flag - multiple alignment reads / unmaped reads
    #-q min. quality
    #-b Bam output
    #-u not zipped

    echo -e "\033[1mFinished mapping sample $sample: $(date +"%Y-%m-%d, %Hh%Mm%Ss")\033[0m" 
    echo
}

samtools_run() # Runs Samtools to check mapping stats, and sorting and indexing BAM files
{
    echo; echo -e "\033[1mRunning Samtools for sample $sample (${n}/${n_samples}): $(date +"%Y-%m-%d, %Hh%Mm%Ss")\033[0m"; echo

    echo Running samtools stats...
    samtools stats ${output_dir}/${sample}.bam > ${output_dir}/${sample}_unfiltered_stats.txt

    # check mapping stats with samtools
    echo Running samtools flagstats...
    samtools flagstat ${output_dir}/${sample}.bam > ${output_dir}/${sample}_unfiltered_mapstats.txt

    # filter out unwanted reads
    echo Filtering mapping...
    samtools view -b -u -q 20 -F 2052 ${output_dir}/${sample}.bam > ${output_dir}/${sample}_filtered.bam

    # sort bam file with samtools
    echo Running samtools sort...
    samtools sort -o ${output_dir}/${sample}_sorted_filtered.bam ${output_dir}/${sample}_filtered.bam

    # check coverage
    echo Running samtools coverage...
    samtools coverage ${output_dir}/${sample}_sorted_filtered.bam > ${output_dir}/${sample}_sorted_filtered_coverage.txt

    echo Running samtools stats...
    samtools stats ${output_dir}/${sample}_sorted_filtered.bam > ${output_dir}/${sample}_sorted_filtered_stats.txt

    #index sorted bam files with samtools
    echo Running samtools index...
    samtools index ${output_dir}/${sample}_sorted_filtered.bam

    rm ${output_dir}/${sample}_filtered.bam  ${output_dir}/${sample}.bam 

    mv ${output_dir}/${sample}_sorted_filtered.bam ${output_dir}/${sample}.bam 

    echo; echo -e "\033[1mFinished running Samtools for sample $sample: $(date +"%Y-%m-%d, %Hh%Mm%Ss")\033[0m"; echo
    
}

main()
{
    getDirs

    n_samples=`cat  $samplelist | sed 's/\r$//' | wc -l`; n=0

              
    for sample in `cat $samplelist | sed 's/\r$//'`; do

        let n=$n+1
        
        bwa_run_paired_end

        samtools_run

    done
        
  

}

main