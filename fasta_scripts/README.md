# awk-bioutils - fasta scripts

# Description

Scripts in this directory are to process standard FASTA files. Sample data, which all usage examples below use, may be found in the `sample_data` subdirectory.

# Sample Data

This sample data was generated from the RefSeq coding sequence sets of five *Drosophila* species:
- *Drosophila busckii* (dbus; GCF_011750605.1)
- *D. melanogaster* (dmel; GCF_000001215.4)
- *D. simulans* (dsim; GCF_016746395.2)
- *D. suzukii* (dsuz; GCF_043229965.1)
- *D. yakuba* (dyak; GCF_016746365.2)

## Directory Structure
```
fasta_scripts/
  fasta_to_tab.awk
  filter_sparse_fasta.awk
  filter_sparse_samples.awk
  longest_isoforms.awk
  multi_to_single.awk
  single_to_multi.awk
  split_fasta.awk
  subset_fasta.awk

  sample_data/
    isoforms.fasta           a FASTA file of Hox gene isoforms (dmel)
    short_isoforms_ml.fasta  the first 100bp of three sequences from isoforms.fasta (multi-line)
    short_isoforms_sl.fasta  the first 100bp of three sequences from isoforms.fasta (single-line)

    headers/
      a_isoforms.txt         headers for the "isoform_A" sequences from isoforms.fasta
      longest_isoforms.txt   headers for the longest isoforms per gene from isoforms.fasta
      pb_isoforms.txt        headers for the proboscipedia sequences from isoforms.fasta
      unsorted_isoforms.txt  headers for random sequences from isoforms.fasta

    filtering/
      antp.fasta             five antp isoforms from five species (dbus - dyak)
      dfd.fasta              four dfd isoforms from four species (dbus - dsuz)
      lab.fasta              three lab isoforms from three species (dbus - dsim)
      pb.fasta               two pb isoforms from two species (dbus & dmel)
      scr.fasta              one scr isoform from one species (dbus)
```

# Usage

The following usage examples assume you are in the `sample_data` subdirectory and that the relevant scripts are in your PATH. 

```
cd /path/to/awk-bioutils/fasta_scripts/sample_data/
export PATH=$PATH:/path/to/awk-bioutils/fasta_scripts
```

This is not strictly necessary but makes commands for running scripts more concise. You may also run the scripts via `./` or `gawk -f` or by providing paths to the relevant scripts/data files. Below, ellipses (`...`) indicate a truncation of the output for visual clarity.


## Convert a FASTA file to a tab-delimited file

### General usage
```
fasta_to_tab.awk input.fasta
```

### Sample command
```
fasta_to_tab.awk short_isoforms_ml.fasta
```

### Sample results
The following data will be printed to stdout:
```
>lab_isoform_A    ATGATGGACGTAAGCAGCATGTACG...
>pb_isoform_A     ATGCAAGAAGTCTGCAGCTCCTTGG...
>scr_isoform_A    ATGGATCCCGACTGTTTTGCGATGT...
```

This script is particularly useful for sorting sequences via `sort`, subsetting FASTA entries via `grep`, calculating sequence lengths (see "Extract the longest isoform per gene" below), appending sequence data to a table, etc.


## Filter out FASTA files containing fewer than N sequences

### General usage
```
filter_sparse_fasta.awk threshold *.fasta
```

Here, `threshold` is the number of sequences a FASTA file must contain to pass the filter.

### Sample command
```
filter_sparse_fasta.awk 4 filtering/*.fasta
```

### Sample results
The following two files, exact copies of the originals aside from the "FSF_" filename prefixes, will be created in the current working directory. These pass the filter because the original *antp* and *dfd* FASTA files contained five and four sequences, respectively.
```
FSF_antp.fasta
FSF_dfd.fasta
```

This script is particularly useful for phylogenetics pipelines, especially in museomics applications, where one may wish to remove loci assembled for too few samples to reduce the prevalence of gappy or ambiguous data.


## Filter out samples found in fewer than N FASTA files

### General usage
```
filter_sparse_samples.awk threshold *.fasta
```

Here, `threshold` is the number of FASTA files a sample must be found in to pass the filter.

### Sample command
```
filter_sparse_samples.awk 4 filtering/*.fasta
```

### Sample results
The following five files with "FSS_" filename prefixes will be created in the current working directory. Since *D. busckii* and *D. melanogaster* were found in five and four of the input files respectively, each FASTA file will contain sequences for only those two species.
```
FSS_antp.fasta
FSS_dfd.fasta
FSS_lab.fasta
FSS_pb.fasta
FSS_scr.fasta
```

This script is particularly useful for phylogenetics pipelines, especially in museomics applications, where one may wish to remove samples for which too few loci assemble to reduce the prevalence of gappy or ambiguous data.


## Extract the longest isoform per gene from a FASTA file

### General usage
```
longest_isoforms.awk input.fasta isoform_string
```

Here, `isoform_string` is a string that separates gene-level and isoform-level accessions across all headers.

### Sample command
```
longest_isoforms.awk isoforms.fasta _isoform_
```

### Sample results
The following data will be printed to stdout:
```
>lab_isoform_A
ATGATGGACGTAAGCAGCATGTACG...
...
>pb_isoform_A
ATGCAAGAAGTCTGCAGCTCCTTGG...
...
>scr_isoform_F
ATGGATCCCGACTGTTTTGCGATGT...
...
```

To see the lengths of all sequences, you may use the following command that pipes the output of the `fasta_to_tab.awk` script into a brief awk one-liner:
```
fasta_to_tab.awk isoforms.fasta | awk 'BEGIN{ OFS = "\t" } { print ( $1, length( $2 ) " bp" ) }'
```

Notice that lab_isoform_A, pb_isoform_A, and scr_isoform_F are longer than all other isoforms of their respective genes. Should multiple isoforms tie for longest, whichever header appears first when sorted alphanumerically will be selected. A simple way to test this is to make a copy of `isoforms.fasta` with sequence pb_isoform_A removed. Doing so will leave pb_isoform_B and pb_isoform_C tied as the longest *pb* isoforms at 2334 bp each. Running the script on this new file will show pb_isoform_B as the longest.

This script is particularly useful for selecting a single representative of one or more genes for phylogenetics, BLAST queries, etc.

## Convert a multi-line FASTA file to single-line

### General usage
```
multi_to_single.awk input.fasta
```

### Sample command
```
multi_to_single.awk short_isoforms_ml.fasta
```

### Sample results
The following data will be printed to stdout:
```
>lab_isoform_A
ATGATGGACGTAAGCAGCATGTACG...
>pb_isoform_A
ATGCAAGAAGTCTGCAGCTCCTTGG...
>scr_isoform_A
ATGGATCCCGACTGTTTTGCGATGT...
```

This script is particularly useful for standardizing file formats, for pipelines where single-line FASTA is preferred over multi-line FASTA, and for saving on storage space since single-line FASTA files achieve higher compression ratios than multi-line FASTA files.

## Convert a single-line FASTA file to multi-line

### General usage
```
single_to_multi.awk input.fasta sequence_width
```

Here, `sequence_width` is the number of sequence characters to print before wrapping it to the following lines.

### Sample command
```
single_to_multi.awk short_isoforms_ml.fasta 25
```

### Sample results
```
>lab_isoform_A
ATGATGGACGTAAGCAGCATGTACG
GCAACCACCCGCACCACCACCATCC
...
>pb_isoform_A
ATGCAAGAAGTCTGCAGCTCCTTGG
ACACGACCTCAATGGGCACCCAAAT
...
>scr_isoform_A
ATGGATCCCGACTGTTTTGCGATGT
CCTCGTACCAGTTCGTCAACTCGCT
...
```

This script is particularly useful for standardizing file formats and for pipelines where multi-line FASTA is preferred over single-line FASTA.

## Split a FASTA file into N single-sequence FASTA files

### General usage
```
split_fasta.awk input.fasta
```

### Sample command
```
split_fasta.awk short_isoforms_ml.fasta
```

This will generate the following interactive prompt:

```
WARNING: This will create 3 new fasta files at "/path/to/awk-bioutils/fasta_scripts/sample_data/".
         Are you sure you would like to proceed?
         Please enter YES to continue or NO to exit:
```

To create these three new FASTA files, enter `YES`. To exit without creating these new FASTA files, enter `NO`. Any input aside from `YES` and `NO` will be treated as an unknown command, and the script will exit without creating new files. Inputs are case-sensitive. This is a safeguard against accidentally creating an unwieldy number of FASTA files. To circumvent this interactive prompt, you may pipe `YES` to the script's stdin like so:
```
echo "YES" | split_fasta.awk short_isoforms_ml.fasta
```

The prompt will still print but will automatically create a success message and will require no manual action.

### Sample results
The following three files will be created, each containing the header they are named after and the corresponding sequence.
```
lab_isoform_A_split.fasta
pb_isoform_A_split.fasta
scr_isoform_A_split.fasta
```

This script is particularly useful for phylogenetics pipelines where multiple loci may be concatenated into files sample-wise but must be split and concatenated loci-wise before alignment.


## Subset a FASTA file based on a file of headers

### General usage
```
subset_fasta.awk headers.txt input.fasta
```

Here, `headers.txt` is a file with the headers (excluding ">") of the sequences you wish to extract, one per line.

### Sample command
```
subset_fasta.awk headers/pb_isoforms.txt isoforms.fasta
```

### Sample results
The following data will be printed to stdout:
```
>pb_isoform_A
ATGCAAGAAGTCTGCAGCTCCTTGG...
...
>pb_isoform_B
ATGCAAGAAGTCTGCAGCTCCTTGG...
...
>pb_isoform_C
ATGCAAGAAGTCTGCAGCTCCTTGG...
...
>pb_isoform_D
ATGCAAGAAGTCTGCAGCTCCTTGG...
...
```

This script is particularly useful for any scenario where specific sequences must be extracted from a FASTA file.

## Considerations

- These scripts can handle most headers well but occasionally struggle with the data-rich GenBank and RefSeq-formatted headers. Especially for scripts such as `split_fasta.awk` and `subset_fasta.awk`, where header strings are used as filenames and queries, it is strongly recommended to use compositionally simple headers containing only alphanumerics, periods, hyphens, and underscores wherever possible.

