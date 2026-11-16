# Test 3: Structural Variants on the Whole Genome (Option 1)

Name: Bryan Nsoh

Server: Sphinx

Repository URL: https://github.com/Bryan-Nsoh/EPP622-2026-StructuralVariants

Project folder: `/lustre/isaac24/proj/UTK0505/bnsoh/test3`

## Data

| Input | Path |
| --- | --- |
| Cherokee Brave HiFi reads, trimmed in lab (SRR34635021) | `/lustre/isaac24/proj/UTK0505/module3_data/analyses/01_fastplong/CherBrave3.trimmed.fq.gz` |
| Appalachian Spring Hap1 reference (11 chromosomes, 1,221,325,582 bp; chr9 = 96,476,405 bp) | `/lustre/isaac24/proj/UTK0505/module3_data/reference_genome/AppSpring_1.0.0_Hap1.Chr.fasta` |
| Lab chr9 mapping stats (course-provided lab run) | `/lustre/isaac24/proj/UTK0505/module3_data/analyses/02_minimap2/CherBrave3.stats.txt` |
| Lab chr9 SV calls (course-provided lab run) | `/lustre/isaac24/proj/UTK0505/module3_data/analyses/03_cutesv/CherBrave3.vcf` |

## Setup

Description: Create project folders and symlink test3 course data into `data/`. Specifically, trimmed Cherokee Brave HiFi reads, the full Appalachian Spring reference genome, and chr9 results from the lab for comparison.

```bash
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
```

Order in which the scripts were run from the project folder:

```bash
cd /lustre/isaac24/proj/UTK0505/bnsoh/test3
conda activate svs
bash scripts/00_setup.sh
nohup bash scripts/01_map.sh > logs/01_map.log 2>&1 &
bash scripts/02_call_svs.sh > logs/02_call_svs.log 2>&1
bash scripts/03_vcf_stats.sh > logs/03_vcf_stats.log 2>&1
bash scripts/04_compare_chr9.sh > logs/04_compare_chr9.log 2>&1
```

## Step 1: Map to the Whole Genome (minimap2)

### Commands

Description: Use minimap2 to map the trimmed HiFi reads to all 11 chromosomes. Then obtain stats for the whole genome and for chr9 by itself so we can compare with the lab's mapping of chr9 alone.

```bash
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
```

### Results

BAM: `/lustre/isaac24/proj/UTK0505/bnsoh/test3/results/1_mapping_whole_genome/CherBrave3.wg.bam`

BAM stats: `/lustre/isaac24/proj/UTK0505/bnsoh/test3/results/1_mapping_whole_genome/CherBrave3.wg.stats.txt`

Chr9-only BAM stats: `/lustre/isaac24/proj/UTK0505/bnsoh/test3/results/1_mapping_whole_genome/CherBrave3.wg.chr9_only.stats.txt`

Coverage per chromosome: `/lustre/isaac24/proj/UTK0505/bnsoh/test3/results/1_mapping_whole_genome/CherBrave3.wg.coverage.txt`

| Stat (`samtools stats`) | Whole genome |
| --- | --- |
| Raw total sequences | 2,172,689 |
| Reads mapped | 2,170,860 (99.92%) |
| Reads unmapped | 1,829 (0.08%) |
| Reads MQ0 | 2,134 |
| Non-primary alignments | 1,269,088 |
| Supplementary alignments | 615,357 |
| Bases mapped (cigar) | 31,987,875,963 |
| Error rate | 5.73% |
| Average read length | 14,866 bp |

| Chromosome (`samtools coverage`) | Length (bp) | Alignments | % covered | Mean depth | Mean MAPQ |
| --- | --- | --- | --- | --- | --- |
| Chr01 | 123,763,987 | 277,771 | 93.36 | 24.95 | 51.9 |
| Chr02 | 114,982,199 | 254,208 | 96.22 | 25.44 | 52.0 |
| Chr03 | 99,349,575 | 219,092 | 97.05 | 25.33 | 51.1 |
| Chr04 | 106,839,336 | 242,369 | 95.67 | 25.25 | 51.6 |
| Chr05 | 118,921,384 | 271,527 | 98.87 | 26.45 | 52.5 |
| Chr06 | 110,187,965 | 244,324 | 96.83 | 25.33 | 51.7 |
| Chr07 | 91,384,834 | 202,204 | 93.25 | 24.23 | 51.3 |
| Chr08 | 100,977,634 | 225,761 | 96.18 | 25.50 | 52.5 |
| Chr09 | 96,476,405 | 215,888 | 97.58 | 25.59 | 52.4 |
| Chr10 | 117,696,505 | 269,764 | 98.39 | 26.59 | 51.5 |
| Chr11 | 140,745,758 | 363,309 | 97.58 | 28.28 | 53.2 |


## Step 2: Call Structural Variants (cuteSV)

### Commands

Description: Run cuteSV with the lab's HiFi settings to find structural variants between Cherokee Brave and the Appalachian Spring reference. 

```bash
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
```

### Results

VCF: `/lustre/isaac24/proj/UTK0505/bnsoh/test3/results/2_sv_calls/CherBrave3.wg.vcf`

| SV type | Whole-genome calls |
| --- | --- |
| DEL | 41,179 |
| INS | 33,360 |
| BND | 2,335 |
| INV | 326 |
| DUP | 145 |
| Total | 77,345 |


## Step 3: VCF Stats (SURVIVOR)

### Commands

Description: Summarize SVs of each type and size for whole genome and for chr9 alone. 

```bash
#!/usr/bin/env bash
set -euo pipefail

VCF=results/2_sv_calls/CherBrave3.wg.vcf
OUT=results/3_vcf_stats

grep "^#" $VCF > $OUT/CherBrave3.wg.chr9_only.vcf
grep "^AppSpring_1.0.0_Hap1_Chr09" $VCF >> $OUT/CherBrave3.wg.chr9_only.vcf

SURVIVOR stats $VCF -1 -1 -1 $OUT/CherBrave3.wg.vcf.stats.txt
SURVIVOR stats $OUT/CherBrave3.wg.chr9_only.vcf -1 -1 -1 $OUT/CherBrave3.wg.chr9_only.vcf.stats.txt
```

### Results

VCF stats: `/lustre/isaac24/proj/UTK0505/bnsoh/test3/results/3_vcf_stats/CherBrave3.wg.vcf.stats.txt`

Chr9-only VCF stats: `/lustre/isaac24/proj/UTK0505/bnsoh/test3/results/3_vcf_stats/CherBrave3.wg.chr9_only.vcf.stats.txt`

Whole genome:

| Length | Del | Dup | Inv | INS | TRA | UNK |
| --- | --- | --- | --- | --- | --- | --- |
| 0-50bp | 14,827 | 0 | 0 | 12,820 | 2,335 | 0 |
| 50-100bp | 9,141 | 0 | 0 | 8,124 | 0 | 0 |
| 100-1000bp | 9,531 | 3 | 103 | 8,421 | 0 | 0 |
| 1000-10000bp | 5,832 | 62 | 96 | 3,871 | 0 | 0 |
| 10000+bp | 1,848 | 80 | 127 | 124 | 0 | 0 |

Chromosome 9 only:

| Length | Del | Dup | Inv | INS | TRA | UNK |
| --- | --- | --- | --- | --- | --- | --- |
| 0-50bp | 1,217 | 0 | 0 | 996 | 92 | 0 |
| 50-100bp | 706 | 0 | 0 | 614 | 0 | 0 |
| 100-1000bp | 792 | 0 | 5 | 633 | 0 | 0 |
| 1000-10000bp | 512 | 4 | 7 | 307 | 0 | 0 |
| 10000+bp | 165 | 6 | 9 | 12 | 0 | 0 |


## Step 4: Chromosome 9, Lab vs. Whole Genome

### Commands

Description: Show mapping stats, SV count by type and depth for both the lab results where reads could only map to chr9 and this run where reads could map to any chromosome so we can compare them.

```bash
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
```

### Results

Output folder: `/lustre/isaac24/proj/UTK0505/bnsoh/test3/results/4_chr9_comparison`

#### Mapping

| Stat | Lab, chr9-only reference | Whole genome (all) | Whole genome (chr9 only) |
| --- | --- | --- | --- |
| Reads mapped | 1,947,086 (89.62% of reads) | 2,170,860 (99.92%) | 169,504 (7.80% of reads) |
| Reads unmapped | 225,603 (10.38%) | 1,829 (0.08%) | n/a |
| Reads MQ0 | 10,973 | 2,134 | 154 |
| Non-primary alignments | 6,204,293 | 1,269,088 | 92,049 |
| Supplementary alignments | 4,331,364 | 615,357 | 46,384 |
| Error rate | 12.35% | 5.73% | 5.56% |
| Chr9 alignments (`samtools coverage`) | 6,278,450 | n/a | 215,888 |
| Chr9 mean depth | 181.98x | n/a | 25.59x |
| Chr9 mean MAPQ | 36.4 | n/a | 52.4 |
| Chr9 % covered | 99.44% | n/a | 97.58% |

#### SV calls on chromosome 9

| SV type | Lab, chr9-only reference | Whole genome (chr9 only) | Change |
| --- | --- | --- | --- |
| DEL | 15,608 | 3,392 | -12,216 (-78.3%) |
| INS | 13,754 | 2,562 | -11,192 (-81.4%) |
| DUP | 529 | 10 | -519 (-98.1%) |
| INV | 204 | 21 | -183 (-89.7%) |
| BND | 0 | 92 | +92 |
| Total | 30,095 | 6,077 | -24,018 (-79.8%) |

#### SV calls on chromosome 9 by size (SURVIVOR)

| Length | DEL lab | DEL whole genome | INS lab | INS whole genome | DUP lab | DUP whole genome | INV lab | INV whole genome |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 0-50bp | 3,892 | 1,217 | 3,836 | 996 | 0 | 0 | 3 | 0 |
| 50-100bp | 3,110 | 706 | 3,030 | 614 | 0 | 0 | 4 | 0 |
| 100-1000bp | 5,529 | 792 | 4,115 | 633 | 104 | 0 | 57 | 5 |
| 1000-10000bp | 2,411 | 512 | 2,712 | 307 | 338 | 4 | 73 | 7 |
| 10000+bp | 666 | 165 | 61 | 12 | 87 | 6 | 67 | 9 |


## Reflection

### 1. Compare your minimap2 mapping stats from the lab (chromosome 9 only) against the whole-genome run. Which stats are red flags now that you have something to compare them to? Cite the actual numbers.

Answer: 


### 2. How many SV calls on chromosome 9 did we get in lab, and how many do you get on chromosome 9 when you map to the whole genome? Break the comparison down by SV type. How do you interpret the change?

Answer:


### 3. This result is surprising. We normally map long reads to a complete reference, but can you think of a situation where you would only have a partial reference? Would this level of mismapping lead you to an incorrect conclusion in that situation?

Answer:


## Directory structure

From `/lustre/isaac24/proj/UTK0505/bnsoh/test3` (`tree -I multiqc_data`):

```
.
├── data
│   ├── lab_chr9_baseline
│   │   ├── CherBrave3.coverage.txt -> /lustre/isaac24/proj/UTK0505/module3_data/analyses/02_minimap2/CherBrave3.coverage.txt
│   │   ├── CherBrave3.stats.txt -> /lustre/isaac24/proj/UTK0505/module3_data/analyses/02_minimap2/CherBrave3.stats.txt
│   │   ├── CherBrave3.vcf -> /lustre/isaac24/proj/UTK0505/module3_data/analyses/03_cutesv/CherBrave3.vcf
│   │   └── CherBrave3.vcf.stats.txt -> /lustre/isaac24/proj/UTK0505/module3_data/analyses/03_cutesv/CherBrave3.vcf.stats.txt
│   ├── reads
│   │   └── CherBrave3.trimmed.fq.gz -> /lustre/isaac24/proj/UTK0505/module3_data/analyses/01_fastplong/CherBrave3.trimmed.fq.gz
│   └── reference
│       ├── AppSpring_1.0.0_Hap1.Chr.fasta -> /lustre/isaac24/proj/UTK0505/module3_data/reference_genome/AppSpring_1.0.0_Hap1.Chr.fasta
│       ├── AppSpring_1.0.0_Hap1.Chr.fasta.fai -> /lustre/isaac24/proj/UTK0505/module3_data/reference_genome/AppSpring_1.0.0_Hap1.Chr.fasta.fai
│       └── AppSpring_1.0.0_Hap1.Chr.mmi -> /lustre/isaac24/proj/UTK0505/module3_data/reference_genome/AppSpring_1.0.0_Hap1.Chr.mmi
├── logs
│   ├── 01_map.log
│   ├── 02_call_svs.log
│   ├── 03_vcf_stats.log
│   └── 04_compare_chr9.log
├── results
│   ├── 1_mapping_whole_genome
│   │   ├── CherBrave3.wg.bam
│   │   ├── CherBrave3.wg.bam.bai
│   │   ├── CherBrave3.wg.chr9_only.stats.txt
│   │   ├── CherBrave3.wg.coverage.txt
│   │   └── CherBrave3.wg.stats.txt
│   ├── 2_sv_calls
│   │   ├── CherBrave3.wg.vcf
│   │   └── workdir
│   ├── 3_vcf_stats
│   │   ├── CherBrave3.wg.chr9_only.vcf
│   │   ├── CherBrave3.wg.chr9_only.vcf.stats.txt
│   │   ├── CherBrave3.wg.chr9_only.vcf.stats.txt_CHR
│   │   ├── CherBrave3.wg.chr9_only.vcf.stats.txtsupport
│   │   ├── CherBrave3.wg.vcf.stats.txt
│   │   ├── CherBrave3.wg.vcf.stats.txt_CHR
│   │   └── CherBrave3.wg.vcf.stats.txtsupport
│   └── 4_chr9_comparison
│       ├── chr9_depth.txt
│       ├── mapping_stats.txt
│       └── sv_counts_by_type.txt
└── scripts
    ├── 00_setup.sh
    ├── 01_map.sh
    ├── 02_call_svs.sh
    ├── 03_vcf_stats.sh
    └── 04_compare_chr9.sh
12 directories, 33 files
```
