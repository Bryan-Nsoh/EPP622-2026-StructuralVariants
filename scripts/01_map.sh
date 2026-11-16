#!/usr/bin/env bash
set -euo pipefail

REF=data/reference/AppSpring_1.0.0_Hap1.Chr.mmi
READS=data/reads/CherBrave3.trimmed.fq.gz
CHR9=AppSpring_1.0.0_Hap1_Chr09
OUT=results/1_mapping_whole_genome

minimap2 -a -x map-hifi -t 32 $REF $READS | samtools sort -@ 8 -m 4G -o $OUT/CherBrave3.wg.bam
samtools index $OUT/CherBrave3.wg.bam
samtools stats $OUT/CherBrave3.wg.bam > $OUT/CherBrave3.wg.stats.txt
samtools stats $OUT/CherBrave3.wg.bam $CHR9 > $OUT/CherBrave3.wg.chr9_only.stats.txt
samtools coverage $OUT/CherBrave3.wg.bam > $OUT/CherBrave3.wg.coverage.txt
