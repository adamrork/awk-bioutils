# awk-bioutils - fastq scripts

# Description

Scripts in this directory are to process standard FASTQ files. Sample data, which all usage examples below use, may be found in the `sample_data` subdirectory.

# Sample Data

This sample data was simulated from *Drosophila melanogaster* (GCF_000001215.4) chr4 using BBTools' randomreads.sh script.

## Directory Structure
```
fastq_scripts/
  fastq_to_fasta.awk

  sample_data/
    dmel_chr4.fastq     a FASTQ file of simulated long read data (100% accuracy)
    dmle_chr4.fastq.gz  the above file, but compressed with gzip
```

# Usage

The following usage examples assume you are in the `sample_data` subdirectory and that the relevant scripts are in your PATH. 

```
cd /path/to/awk-bioutils/fastq_scripts/sample_data/
export PATH=$PATH:/path/to/awk-bioutils/fastq_scripts
```

This is not strictly necessary but makes commands for running scripts more concise. You may also run the scripts via `./` or `gawk -f` or by providing paths to the relevant scripts/data files. Below, ellipses (`...`) indicate a truncation of the output for visual clarity.

## Convert a FASTQ file to FASTA

### General usage
```
fastq_to_fasta.awk input.fastq
```

### Sample command
```
fastq_to_fasta.awk dmel_chr4.fastq
```

To convert the gzipped FASTQ file, run the following:
```
gunzip -c dmel_chr4.fastq.gz | fastq_to_fasta.awk -
```

### Sample results
The following data will be printed to stdout:
```
>SYN_0_381973_383483_0_+_389973_1_._NC_004353.4 1:
CCAAATGTTTCAAATTCTTCGCTTGTCCAAACAGTATAGTTTTGTACAGGGTCTTGTTCCGCCTAATATGTGTAC...
>SYN_1_139046_140581_0_+_147046_1_._NC_004353.4 1:
AGAGGTGGCTCTCCAGGCTCTCTGAGAGAGCGGACAGCTCTATAGCCAGCACCTTTCTTTCTCGCATACAGTGAC...
>SYN_2_164803_166265_0_-_172803_1_._NC_004353.4 1:
AATTTAAACATGATGCGTAATCGTGAAATCAAGTTGTTTAAAAAATATTTAACTATCATTAAAGTGTTAGGACCC...
...
```

This script is particularly useful for converting long read data from FASTQ to FASTA format, a prerequisite in many long read data analysis pipelines.

