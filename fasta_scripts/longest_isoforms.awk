#!/usr/bin/gawk -f

## AWK BioUtils - longest_isoforms.awk
## BSD 3-Clause License
## Copyright (C) 2025 Adam M. Rork

### This script extracts the longest isoform per gene from a fasta file. ###
## USAGE: ./longest_isoforms.awk input.fasta isoform_string ##

BEGIN {
	# Assign the input fasta file and the isoform string to variables. Then, quash the latter positional argument. #
	if ( ARGC == 3 ) {
		INPUT_FILE = ARGV[1]
		PATTERN = ARGV[2]

		ARGV[2] = ""

	# If <2 or >2 arguments are provided, print a brief help message and exit. #
	} else {
		printf( "\n%s\n\n", "USAGE: ./longest_isoforms.awk input.fasta isoform_string" )
		printf( "%-9s%s\n", "", "where:" )
		printf( "%-16s%20-s%s\n", "", "input.fasta", "a standard FASTA file" )
		printf( "%-16s%20-s%s\n\n", "", "isoform_string", "the isoform identity string used in headers" )

		EXITFLAG = 1
		exit 1
	}
}

# Split the fasta header into two strings on the provided pattern and reset the sequence length variable. #
/^>/ {
	seqlen = ""
	split( $0, segments, PATTERN )
	next
}

# Calculate the sequence length and append that value to an array alongside the split header. #
!/^>/ {
	seqlen += length( $0 )
	arr[segments[1]][segments[2]] = seqlen
}

END {
	# If we exited in the BEGIN block, ensure we exit early in the END block. #
	if ( EXITFLAG ) { exit 1 }

	# Sort each gene by descending sequence length, breaking ties by the order of the isoform strings. #
	PROCINFO["sorted_in"] = "@val_num_desc"

	# For each gene, extract the header of the top (longest) isoform only and store it in a new array. #
	for ( gen in arr ) {
		for ( iso in arr[gen] ) {
			longarr[gen PATTERN iso]
			break
		}
	}

	# Parse the fasta file until a header is found. #
	while ( ( getline record < INPUT_FILE ) > 0 ) {
		if ( record ~ "^>" ) {

			# If the current header has a match in the array, set seq_match to TRUE. #
			if ( record in longarr ) {
				seq_match = "TRUE"

			} else {
				seq_match = "FALSE"
			}
		}

		# Print header and sequence records until a non-matching header is found, and repeat. #
		if ( seq_match == "TRUE" ) {
			printf( "%s\n", record )
		}
	}
}

