# awk-bioutils - general scripts

# Description

Scripts in this directory are for processing general text files. Sample data, which all usage examples below use, may be found in the `sample_data` subdirectory.

# Sample Data

This sample data was created manually.

## Directory Structure
```
general_scripts/
  condense_columns.awk
  deinterleave_files.awk
  expand_columns.awk
  find_and_replace.awk
  interleave_files.awk

  sample_data/
    long.txt         a two-field tab-delimited file,
    wide.txt         a multi-field file with " : " and ", " delimiters

    file_A.txt       the first of two files with entries to interleave
    file_B.txt       the second of two files with entries to interleave
    file_I.txt       the result of interleaving file_A.txt and file_B.txt

    dictionary.txt   a file with strings to find and their replacements
    file_to_fix.txt  a file containing a sentence in need of editing
```

# Usage

The following usage examples assume you are in the `sample_data` subdirectory and that the relevant scripts are in your PATH. 

```
cd /path/to/awk-bioutils/general_scripts/sample_data/
export PATH=$PATH:/path/to/awk-bioutils/general_scripts
```

This is not strictly necessary but makes commands for running scripts more concise. You may also run the scripts via `./` or `gawk -f` or by providing paths to the relevant scripts/data files. Below, ellipses (`...`) indicate a truncation of the output for visual clarity.


## Convert a multi-field (wide) file to a two-field (long) file

### General usage

```
condense_columns.awk input.txt "in_keyval_delim" "in_valval_delim" "out_keyval_delim"
```

Here, `"in_keyval_delim"` is the delimiter between the first two fields of your input file. The value of `"in_valval_delim"` is the delimiter between all other fields of your input file. The value of `"out_keyval_delim"` is the output delimiter between the two fields of your output. All delimiters must be within double quotes.

### Sample command
```
condense_columns.awk wide.txt " : " ", " "\t"
```

### Sample results
The following data will be printed to stdout:
```
A	01
A	02
...
B	06
B	07
...
```

This script is particularly useful for preparing data for file joins, feature extraction, report generation, and several other tasks.


## Deinterleave one interleaved file into two files, one N-record entry at a time

### General usage
```
deinterleave_files.awk input.txt lines_per_entry
```

Here, `lines_per_entry` is the number of lines constituting an entry in the interleaved file.

### Sample command
```
deinterleave_files.awk file_I.txt 3
```

### Sample results
The following files with the "A_" and "B_" filename prefixes will be created in the current working directory. `A_file_I.txt` contains all odd-numbered entries, and `B_file_I.txt` contains all even-numbered entries.
```
A_file_I.txt
B_file_I.txt
```

This script is particularly useful for preprocessing data for pipelines that accept or require pairs of files, for generating reports, etc.


## Convert a two-field (long) file to a multi-field (wide) file

### General usage
```
expand_columns.awk input.txt "in_keyval_delim" "out_keyval_delim" "out_valval_delim"
```

Here, `"in_keyval_delim"` is the delimiter between the two fields of your input file. The value of `out_keyval_delim"` is the delimiter between the first two fields of your output and the value of `"out_valval_delim"` is the delimiter between all other fields of your output. All delimiters must be within double quotes.

### Sample command
```
expand_columns.awk long.txt "\t" " : " ", "
```

### Sample results
The following data will be printed to stdout:
```
A : 01, 02, 03, 04, 05
B : 06, 07, 08, 09, 10
C : 11, 12, 13, 14, 15
D : 16, 17, 18, 19, 20
```

As above, this script is particularly useful for preparing data for file joins, feature extraction, report generation, and several other tasks.


## Replace all occurrences of strings in a file with strings from a key-value file

### General usage
```
find_and_replace.awk dictionary.txt input.txt
```

Here, `dictionary.txt` is a tab-delimited file with the strings you wish to replace in field 1 and their replacements in field 2.

### Sample command
```
find_and_replace.awk dictionary.txt file_to_fix.txt
```

### Sample results
The following data will be printed to stdout:
```
...

Awk is a powerful programming language for data extraction, file formatting, and several other tasks!
```

This script is particularly useful for making several changes to one or more files without crafting verbose `sed` or `gsub` commands. This script was designed for string substitution and does not handle regex-based substitutions particularly well. Thus, it is recommended to use `sed` or `gsub` for regex-based tasks.

## Interleave two files, one N-record entry at a time

### General usage
```
interleave_files.awk input_A.txt input_B.txt lines_per_entry
```

Here, `lines_per_entry` is the number of lines constituting an entry in each file.

### Sample command
```
interleave_files.awk file_A.txt file_B.txt 3
```

### Sample results
The following data will be printed to stdout:
```
ENTRY A - 01
ENTRY A - 02
ENTRY A - 03
ENTRY B - 04
ENTRY B - 05
ENTRY B - 06
...
```
This script is particularly useful for preprocessing data for pipelines that accept or require interleaved files, generating reports, and potentially saving on storage space since interleaved files may achieve higher compression ratios than non-interleaved files, etc.

