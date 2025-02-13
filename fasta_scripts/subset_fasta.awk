#!/usr/bin/gawk -f

## AWK BioUtils - subset_fasta.awk
## BSD 3-Clause License
## Copyright (C) 2025 Adam M. Rork

### This script subsets a fasta file based on headers specified in a secondary file. ###
## USAGE: ./subset_fasta.awk headers.txt input.fasta ##

BEGIN {
	if ( ARGC == 3 ) {
		# A de facto no-op, skipping the if block if two positional arguments are provided. #
		{}

	# If <2 or >2 arguments are provided, print a brief help message and exit. #
	} else {
		printf( "\n%s\n\n", "USAGE: ./subset_fasta.awk headers.txt input.fasta" )
		printf( "%-9s%s\n", "", "where:" )
		printf( "%-16s%20-s%s\n", "", "headers.txt", "a text file of sequence headers, one per line" )
		printf( "%-16s%20-s%s\n\n", "", "input.fasta", "a standard FASTA file" )

		exit 1
	}
}

# Create an array of keys from the headers file. #
NR == FNR {
	arr[$1]
	next
}

# Check if the current record is a header present in the array. #
/^>/ {
	header = substr( $0, 2 )

	# If so, set seq_match to true. If not, set it to false. #
	if ( header in arr ) {
		seq_match = "TRUE"

	} else {
		seq_match = "FALSE"
	}
}

# So long as seq_match is TRUE, print records until the next header is found, and repeat. #
{
	if ( seq_match == "TRUE" ) {
		printf( "%s\n", $0 )
	}
}

