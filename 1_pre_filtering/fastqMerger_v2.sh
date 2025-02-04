#! /bin/bash
dir='/mnt/data2/Project_Polli_agro/Operational/4_data_analysis/2_rawdata_merge_and_rename/'

mkdir ${dir}/unmerged_files

#merge samples that have files in both batches; first batch only samples will be ignored
for file in `ls -l $dir | awk '{ print $ 9}' | grep 'R1_2nd' | sed 's/_R1_2nd.fastq.gz//'` ; do
	
	echo Handling sample $file.
	
	#files
	newer_file_1=${dir}${file}_R1_2nd.fastq.gz
	newer_file_2=${dir}${file}_R2_2nd.fastq.gz

	older_file_1=${dir}${file}_R1_1st.fastq.gz
	older_file_2=${dir}${file}_R2_1st.fastq.gz

	merged_file_1=${dir}${file}_R1_merged.fastq.gz
	merged_file_2=${dir}${file}_R2_merged.fastq.gz

	#merge files
	echo Merging R1 $(date "+%T").
	zcat $older_file_1 $newer_file_1 | gzip > $merged_file_1
	echo Merging R2 $(date "+%T").
	zcat $older_file_2 $newer_file_2 | gzip > $merged_file_2

	#move unmerged files into subdirectory
	echo Moving unmerged files.
	mv -v $older_file_1 ${dir}/unmerged_files/${file}_R1_1st_unmerged.fastq.gz
	mv -v $older_file_2 ${dir}/unmerged_files/${file}_R2_1st_unmerged.fastq.gz
	mv -v $newer_file_1 ${dir}/unmerged_files/${file}_R1_2nd_unmerged.fastq.gz
    mv -v $newer_file_2 ${dir}/unmerged_files/${file}_R2_2nd_unmerged.fastq.gz

done
