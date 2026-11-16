#!/usr/bin/env bash
set -euo pipefail

DATA=/lustre/isaac24/proj/UTK0505/module3_data
cd /lustre/isaac24/proj/UTK0505/bnsoh/test3

mkdir -p data/reads data/reference data/lab_chr9_baseline scripts logs
mkdir -p results/1_mapping_whole_genome results/2_sv_calls results/3_vcf_stats results/4_chr9_comparison

ln -sf $DATA/analyses/01_fastplong/CherBrave3.trimmed.fq.gz data/reads/

ln -sf $DATA/reference_genome/AppSpring_1.0.0_Hap1.Chr.fasta data/reference/
ln -sf $DATA/reference_genome/AppSpring_1.0.0_Hap1.Chr.fasta.fai data/reference/
ln -sf $DATA/reference_genome/AppSpring_1.0.0_Hap1.Chr.mmi data/reference/

ln -sf $DATA/analyses/02_minimap2/CherBrave3.stats.txt data/lab_chr9_baseline/
ln -sf $DATA/analyses/02_minimap2/CherBrave3.coverage.txt data/lab_chr9_baseline/
ln -sf $DATA/analyses/03_cutesv/CherBrave3.vcf data/lab_chr9_baseline/
ln -sf $DATA/analyses/03_cutesv/CherBrave3.vcf.stats.txt data/lab_chr9_baseline/
