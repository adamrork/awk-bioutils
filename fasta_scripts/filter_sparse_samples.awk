#!/usr/bin/gawk -f

## AWK BioUtils - filter_sparse_samples.awk
## BSD 3-Clause License
## Copyright (C) 2025 Adam M. Rork

### This script subsets fasta files by removing entries for samples present in fewer than N files. ###
## USAGE: ./filter_sparse_samples.awk threshold *.fasta ##

BEGIN {
	# Assign the file threshold to a variable. Then, quash the positional argument. #
	if ( ARGC >= 3 ) {
		THRESHOLD = ARGV[1]

		ARGV[1] = ""

	# If <2 arguments are provided, print a brief help message and exit. #
	} else {
		printf( "\n%s\n\n", "USAGE: ./filter_sparse_samples.awk threshold *.fasta" )
		printf( "%-9s%s\n", "", "where:" )
		printf( "%-16s%20-s%s\n", "", "threshold", "minimum files a sample must be present in to pass the filter" )
		printf( "%-16s%20-s%s\n\n", "", "*.fasta", ">= 2 standard fasta file(s) via globbing or explicit arguments" )

		EXITFLAG = 1
		exit 1
	}
}

# Count the number of times each sample occurs across all files. #
/^>/ {
	arr[$0]++
}

END {
	# If we exited in the BEGIN block, ensure we exit early in the END block. #
	if ( EXITFLAG ) { exit 1 }

	# Identify which samples are sufficiently abundant to pass the filter. #
	for ( sample in arr ) {
		if ( arr[sample] >= THRESHOLD ) {
			passing[sample] = arr[sample]
		}
	}

	# For each fasta file provided... #
	for ( n = 2; n < ARGC; n++ ) {

		# Extract filenames from paths so we have clean strings to name our output files after. #
		fastafile = ARGV[n]
		gsub(/.*\//, "", fastafile)

		# Extract each header from said files #
		while ( ( getline record < ARGV[n] ) > 0 ) {
			if ( record ~ "^>" ) {

				# Determine if each header belongs to a passing sample. #
				if ( record in passing ) {
					matching = "TRUE"

				} else {
					matching = "FALSE"
				}
			}

			# If the header belongs to a passing sample, print it and its sequence records to a file. #
			if ( matching == "TRUE" ) {
				printf( "%s\n", record ) >> "FSS_"fastafile
			}
		}
	}
}

