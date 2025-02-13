# awk-bioutils
A suite of GNU AWK scripts for performing various standard bioinformatics tasks.

# Installation
These scripts require no installation. You may obtain them by cloning this repository with the following command:

```
git clone https://github.com/adamrork/awk-bioutils.git
```

# Dependencies
These scripts were developed with GNU AWK (gawk), their core dependency. They have been tested on CentOS 7, specifically.

#### Required:
- GNU AWK (=> 4.0.0)

### Installation
GNU AWK should be installed on most Linux operating systems by default. If you do not have GNU AWK installed, please consult [the official GNU AWK documentation](https://www.gnu.org/software/gawk/manual/gawk.html#Installation) for information on how to do so.

You may also choose to install GNU AWK via conda:
```
conda install -c conda-forge gawk
```

To test that your version of awk is GNU AWK, run `awk --version`. If GNU AWK is installed, you should see a message referencing it displayed.

# Introduction
In bioinformatics workflows, there is often a need to extract features from data pre and post-analysis, convert between file formats, verify the quality of data generated, filter out low-quality data, etc. Although many scripts and one-liners exist for performing several such tasks, many more tasks have no formalized solutions. Additionally, in cases where users need to perform a single type of operation, perhaps only a few times for a particular project, it may be undesirable to install larger software suites and their dependencies to access a single tool.

AWK BioUtils is a collection of standalone GNU AWK scripts that perform some of the aforementioned bioinformatics tasks. All scripts were written to be concise, efficient, user-friendly, and free of non-standard dependencies. Please feel free to fork this repository, contribute your thoughts and suggestions, and report bugs in the Issues tab.

# Repository Structure

Scripts in this repository are organized into directories based on the file types they process. For example, scripts for processing FASTA data are in the `fasta_scripts` directory. Within these main directories are subdirectories named `sample_data` that contain small example datasets for testing. Also within the main directories are additional README files with detailed usage information for each script.

# Considerations

In general, there are a few conventions that apply to these scripts:

1. All scripts assume your data are uncompressed. Should you need to analyze compressed files, you must either decompress them or pipe their decompressed contents into a script's stdin like so:
```
gunzip -c input.fastq.gz | ./fastq_to_fasta.awk -
```

2. All scripts assume gawk is installed in `/usr/bin/` by default. If it is installed elsewhere but is in your PATH, you may still use scripts as follows:
```
gawk -f fastq_to_fasta.awk input.fastq
```

If GNU AWK is the only implementation installed, `awk` and `gawk` should be synonymous, and either will likely work. The use of `gawk` here is simply for clarity.

3. By default, most scripts print results to stdout. You may redirect their outputs to a file or use them within pipelines. Some scripts print results to files by default; such cases are noted in their usage information.

# Future Development

- Add logic to ensure users are not inputting compressed or malformed data.
- Add formal command line options so folks need not use positional arguments.
- Add additional FASTA, FASTQ, GTF, GFF, SAM, and VCF processing scripts.
- Consider adding options for calling gunzip within each script.
- Test compatibility with mawk and nawk.

