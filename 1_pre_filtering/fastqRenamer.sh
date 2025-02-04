#! /bin/bash/

#Renames files based on key given in txt file

#txt should look like:
#	1A1		sample1
#	2B9		sample7
#	3G4		sample42

directory="/mnt/data2/Project_Polli_agro/Operational/0_pre_analysis_rawdata_formating/2_merge_and_rename/"
name_file="/mnt/data2/Project_Polli_agro/Operational/2_metadata/02_SSF_samples/01_sample_files/names_changed_2run.txt"

# Log file to register the renaming process
touch ${directory}renaming.log

# Rename
cat $name_file | while read line || [[ -n $line ]]; do
	first=$(echo $line | awk '{print $1}')
	second=$(echo $line | awk '{print $2}')

	echo -e "\033[1mRenaming $first to $second:\033[0m"
	rename -v "s/${first}_/${second}_/" ${directory}${first}_*
	echo

	# write command to logfile
	(
	echo -e "\033[1mRenaming $first to $second:\033[0m" 
	echo rename -v "s/${first}_/${second}_/" ${directory}${first}_* 
	echo 
	) >> ${directory}renaming.log

done
