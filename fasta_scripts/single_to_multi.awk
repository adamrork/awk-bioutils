#!/usr/bin/gawk -f

## AWK BioUtils - single_to_multi.awk
## BSD 3-Clause License
## Copyright (C) 2025 Adam M. Rork

### This script converts a single-line fasta file to a multi-line FASTA file. ###
## USAGE: ./single_to_multi.awk input.fasta sequence_width ##

BEGIN {
	# Assign the desired sequence width to a variable. Then, quash the positional argument. #
	if ( ARGC == 3 ) {
		SEQ_WIDTH = ARGV[2]

		ARGV[2] = ""

	# If <2 or >2 arguments are provided, print a brief help message and exit. #
	} else {
		printf( "\n%s\n\n", "USAGE: ./single_to_multi.awk input.fasta sequence_width" )
		printf( "%-9s%s\n", "", "where:" )
		printf( "%-16s%20-s%s\n\n", "", "input.fasta", "a standard single-line FASTA file" )

		exit 1
	}
}

# If the current record is a header, print it to a new line. #
/^>/ {
	printf( "%s\n", $0 )
	next
}

# Append the sequences following the header to subsequent lines of length SEQ_WIDTH until a new header is found. #
!/^>/ {
	for ( i = 1; i <= length( $0 ); i += SEQ_WIDTH )
		printf( "%s\n", substr( $0, i, SEQ_WIDTH ) )
}

