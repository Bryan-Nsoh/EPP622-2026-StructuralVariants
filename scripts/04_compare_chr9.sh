#!/usr/bin/env bash
set -euo pipefail

LAB=data/lab_chr9_baseline
WG=results/1_mapping_whole_genome
SV=results/3_vcf_stats
OUT=results/4_chr9_comparison

for f in $LAB/CherBrave3.stats.txt $WG/CherBrave3.wg.stats.txt $WG/CherBrave3.wg.chr9_only.stats.txt; do
  echo "== $f"
  grep -E "reads mapped:|reads unmapped:|reads MQ0:|non-primary|supplementary|error rate:" $f
done > $OUT/mapping_stats.txt

grep Chr09 $LAB/CherBrave3.coverage.txt $WG/CherBrave3.wg.coverage.txt > $OUT/chr9_depth.txt

for f in $LAB/CherBrave3.vcf $SV/CherBrave3.wg.chr9_only.vcf; do
  echo "== $f"
  grep -o "SVTYPE=[A-Z]*" $f | sort | uniq -c
done > $OUT/sv_counts_by_type.txt
