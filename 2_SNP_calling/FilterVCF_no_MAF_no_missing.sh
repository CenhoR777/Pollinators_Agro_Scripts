#!/bin/bash

# bash filterVCF.sh input.vcf.gz filtered_output.vcf.gz thinned_output.vcf.gz

input_dataset=$1
output_filtered_dataset=$2
output_thinned_dataset=$3

# genotype-level depth threshold
minDP=8

# FILTERING

# Set low-quality genotypes to missing:
# - GQ < 20
# - DP < minDP
bcftools filter "${input_dataset}" \
  --set-GTs . \
  --exclude "FMT/GQ<20 | FMT/DP<${minDP}" \
  --threads 20 -Ou |

# Recalculate useful INFO tags after masking low-quality genotypes
bcftools +fill-tags --threads 20 -Ou -- \
  -t INFO/AN,INFO/AC,INFO/F_MISSING,INFO/MAF,'INFO/TOTAL_DP:1=int(sum(FORMAT/DP))','INFO/MEAN_DP:1=avg(FORMAT/DP)','INFO/MAC:1=MAC' |

# Keep only biallelic SNPs and remove loci that became non-polymorphic
bcftools view \
  --min-alleles 2 \
  --max-alleles 2 \
  --types snps \
  --include 'INFO/AC>0 & INFO/AC<INFO/AN' \
  --threads 20 -Ou |

# Save filtered, non-thinned VCF
bcftools +variant-distance -Oz -o "${output_filtered_dataset}"

# Index the filtered VCF
bcftools index -t "${output_filtered_dataset}"

# THINNING

# Thin with a 300 bp window and save thinned VCF
bcftools +prune -w 300bp -n 1 -N 1st -Ou "${output_filtered_dataset}" | \
bcftools +variant-distance -Oz -o "${output_thinned_dataset}"

# Index the thinned VCF
bcftools index -t "${output_thinned_dataset}"

# COUNTS
bcftools +counts "${output_filtered_dataset}" > "${output_filtered_dataset}.counts"
bcftools +counts "${output_thinned_dataset}" > "${output_thinned_dataset}.counts"