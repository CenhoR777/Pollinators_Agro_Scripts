#!/bin/bash

# Very simple script to run VCF filtering with BCFTools.
# bash filterVCF.sh input.vcf filtered_output.vcf thinned_output.vcf

input_dataset=$1
output_filtered_dataset=$2
output_thinned_dataset=$3

# FILTERING

# genotype level filtering: set genotypes with depth bellow 5 and quality bellow 30 to missing (not used)
#bcftools filter ${input_dataset} --set-GTs . --exclude 'FMT/DP<5 & FMT/GQ<30' --threads 20 -Ou | 

# add tags for SNP level filtering
bcftools +fill-tags ${input_dataset} --threads 20 -Ou -- -t INFO/AN,INFO/F_MISSING,INFO/MAF,'INFO/TOTAL_DP:1=int(sum(FORMAT/DP))','INFO/MEAN_DP:1=avg(FORMAT/DP)','INFO/MAC:1=MAC' |

# SNP level filtering: include only bi-allelic SNPs, with minor allele count of equal or above 2, mean depth between 10 and 100 and a missing frequency bellow 20%
bcftools view --min-alleles 2 --max-alleles 2 --include 'INFO/MAC >= 2 & INFO/MEAN_DP >= 10 & INFO/MEAN_DP <= 100 & F_MISSING <= 0.2' --threads 20 -Ou |

# add variant distance information to filtered SNPs
bcftools +variant-distance -Oz -o ${output_filtered_dataset}

# THINNING

# dataset thinning with window of 1000bp and update variant distance information
bcftools +prune -w 1000bp -n 1 -N 1st -Ou ${output_filtered_dataset} | bcftools +variant-distance -Oz -o ${output_thinned_dataset}

# COUNTS
# create a .txt file with SNP basic information about dataset
bcftools +counts ${output_filtered_dataset} > ${output_filtered_dataset}.counts
bcftools +counts ${output_thinned_dataset} > ${output_thinned_dataset}.counts
