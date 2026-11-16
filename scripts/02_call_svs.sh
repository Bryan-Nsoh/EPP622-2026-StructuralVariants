#!/usr/bin/env bash
set -euo pipefail

BAM=results/1_mapping_whole_genome/CherBrave3.wg.bam
REF=data/reference/AppSpring_1.0.0_Hap1.Chr.fasta
OUT=results/2_sv_calls

mkdir -p $OUT/workdir
cuteSV $BAM $REF $OUT/CherBrave3.wg.vcf $OUT/workdir \
  --max_cluster_bias_INS 1000 --diff_ratio_merging_INS 0.9 \
  --max_cluster_bias_DEL 1000 --diff_ratio_merging_DEL 0.5 \
  --genotype --threads 16
