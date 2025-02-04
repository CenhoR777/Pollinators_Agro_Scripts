#! /bin/bash/

# Copies files from a directory based on sample names given in a file (one per line).

input_directory="/mnt/data2/Project_Polli_agro/Operational/0_pre_analysis_rawdata_formating/2_merge_and_rename/"
output_directory="/mnt/data2/Project_Polli_agro/Operational/1_raw_data/"
sample_file="/mnt/data2/Project_Polli_agro/Operational/2_metadata/02_SSF_samples/01_sample_files/SSF_sample_list_2nd_run.txt"
suffix1=*_R1*fastq.gz
suffix2=*_R2*fastq.gz

# Log file to register the renaming process
touch ${output_directory}copy_files.log

# Make copy
for sample in `cat $sample_file | sed 's/\r$//'` ; do
	location1=$input_directory$sample$suffix1
	location2=$input_directory$sample$suffix2
	
	echo -e "\033[1mCopying sample $sample.\033[0m"
	cp -v $location1 $output_directory
	cp -v $location2 $output_directory
	echo

	# write command to logfile
	(
	echo -e "\033[1mCopying sample $sample.\033[0m"
	echo cp -v $location1 $output_directory
	echo cp -v $location2 $output_directory
	echo
	) >> ${output_directory}copy_files.log

done
