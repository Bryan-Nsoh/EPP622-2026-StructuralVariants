#!/usr/bin/env bash
set -euo pipefail

VCF=results/2_sv_calls/CherBrave3.wg.vcf
OUT=results/3_vcf_stats

grep "^#" $VCF > $OUT/CherBrave3.wg.chr9_only.vcf
grep "^AppSpring_1.0.0_Hap1_Chr09" $VCF >> $OUT/CherBrave3.wg.chr9_only.vcf

SURVIVOR stats $VCF -1 -1 -1 $OUT/CherBrave3.wg.vcf.stats.txt
SURVIVOR stats $OUT/CherBrave3.wg.chr9_only.vcf -1 -1 -1 $OUT/CherBrave3.wg.chr9_only.vcf.stats.txt

bcftools stats $VCF > $OUT/CherBrave3.wg.bcftools_stats.txt
bcftools stats $OUT/CherBrave3.wg.chr9_only.vcf > $OUT/CherBrave3.wg.chr9_only.bcftools_stats.txt
bcftools stats data/lab_chr9_baseline/CherBrave3.vcf > $OUT/CherBrave3.lab_chr9.bcftools_stats.txt
