#! /bin/bash

input_dir='/mnt/data2/Project_Polli_agro/ORIGINAL_RAWDATA/data_20201026/'
output_dir='/mnt/data2/Project_Polli_agro/Operational/4_data_analysis/1_rawdata_formating/1_fastqTipCutter/data_20201026/'
fastqTipCutter_location='/mnt/data2/Project_Polli_agro/Operational/5_scripts/fastqTipCutter.py'

for file in `ls -l $input_dir | awk '{print $9}' | grep 'fastq'`; do
	echo $file
	python3 $fastqTipCutter_location $input_dir$file | gzip > $output_dir${file}
done
