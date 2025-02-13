#!/usr/bin/gawk -f

## AWK BioUtils - filter_sparse_fasta.awk
## BSD 3-Clause License
## Copyright (C) 2025 Adam M. Rork

### This script filters out fasta files that have fewer than N sequences. ###
## USAGE: ./filter_sparse_fasta.awk threshold *.fasta ##

BEGIN {
	# Assign the sequence threshold to a variable. Then, quash the positional argument. #
	if ( ARGC >= 3 ) {
		THRESHOLD = ARGV[1]

		ARGV[1] = ""

	# If <2 arguments are provided, print a brief help message and exit. #
	} else {
		printf( "\n%s\n\n", "USAGE: ./filter_sparse_fasta.awk threshold *.fasta" )
		printf( "%-9s%s\n", "", "where:" )
		printf( "%-16s%20-s%s\n", "", "threshold", "minimum sequences a file must have to pass the filter" )
		printf( "%-16s%20-s%s\n\n", "", "*.fasta", ">= 2 standard fasta file(s) via globbing or explicit arguments" )

		EXITFLAG = 1
		exit 1
	}

}

# Count the number of sequences found per file and append these counts to their filenames in an array. #
/^>/ {
	arr[FILENAME]++
}

END {
	# If we exited in the BEGIN block, ensure we exit early in the END block. #
	if ( EXITFLAG ) { exit 1 }

	# For each input file provided... #
	for ( file in arr ) {

		# Extract filenames from paths so we have clean strings to name our output files after. #
		fastafile = file
		gsub(/.*\//, "", fastafile)

		# Create new copies of files that passed the filter, prefixed with "FSF_" (script acronym). #
		if ( arr[file] >= THRESHOLD ) {
			while ( ( getline record < file ) > 0 ) {
				printf( "%s\n", record ) >> "FSF_"fastafile
			}
		}
	}
}

