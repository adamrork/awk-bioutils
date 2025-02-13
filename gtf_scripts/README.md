# awk-bioutils - gtf scripts

# Description

Scripts in this directory process standard GTF files. Sample data, which all usage examples below use, may be found in the `sample_data` subdirectory.

# Sample Data

All sample data was subsetted from the RefSeq *D. melanogaster* (GCF_000001215.4) GTF file.

## Directory Structure
```
gtf_scripts/
  gtf_to_bed6.awk
  intron_lengths.awk

  sample_data/
    dmel_chr4.gtf  a file of GTF entries for features on chromosome 4
    dmel_chrY.gtf  a file of GTF entries for features on the Y chromosome
    dmel_mt.gtf    a file of GTF entries for features on the mitochondrial genome
```

# Usage

The following usage examples assume you are in the `sample_data` subdirectory and that the relevant scripts are in your PATH. 

```
cd /path/to/awk-bioutils/gtf_scripts/sample_data/
export PATH=$PATH:/path/to/awk-bioutils/gtf_scripts
```

This is not strictly necessary but makes commands for running scripts more concise. You may also run the scripts via `./` or `gawk -f` or by providing paths to the relevant scripts/data files. Below, ellipses (`...`) indicate a truncation of the output for visual clarity.

## Convert a GTF file to BED6 format

### General usage
```
gtf_to_bed6.awk input.gtf
```

### Sample command
```
gtf_to_bed6.awk dmel_chrY.gtf
```

### Sample results
The following data will be printed to stdout:
```
NC_024512.1	9832	10786	NM_001110682.3	0	+
NC_024512.1	22249	137486	NM_001015499.4	0	-
NC_024512.1	146091	192020	NM_001110656.3	0	-
NC_024512.1	336380	563165	NM_001111012.3	0	+
NC_024512.1	573087	664173	NM_001015505.5	0	+
...
```

This script is particularly useful for pipelines requiring BED6 format rather than GTF format. To instead convert to BED3, BED4 or BED5 format, you may pipe this into the following awk one-liners:

#### GTF-to-BED3
`gtf_to_bed6.awk dmel_chrY.gtf | awk '{ print( $1, $2, $3 ) }'`

#### GTF-to-BED4
`gtf_to_bed6.awk dmel_chrY.gtf | awk '{ print( $1, $2, $3, $4 ) }'`

#### GTF-to-BED5
`gtf_to_bed6.awk dmel_chrY.gtf | awk '{ print( $1, $2, $3, $4, $5 ) }'`


## Extract intron lengths from a GTF file

### General usage
```
intron_lengths.awk input.gtf
```

### Sample command
```
intron_lengths.awk dmel_chr4.gtf
```

### Sample results
The following data will be printed to stdout:
```
48	6
49	16
50	5
51	26
52	6
...
```

Values in the first field are intron lengths in bp. Values in the second field are the number of times said intron length is found in the GTF file. This script is particularly useful for informing how to set intron length parameters in splice-aware alignment and genome-guided transcriptome assembly software.

