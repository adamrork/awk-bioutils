#!/usr/bin/gawk -f

## AWK BioUtils - multi_to_single.awk
## BSD 3-Clause License
## Copyright (C) 2025 Adam M. Rork

### This script converts a multi-line FASTA file to a single-line FASTA file. ###
## USAGE: ./multi_to_single.awk input.fasta ##

BEGIN {
	if ( ARGC == 2 ) {
		# A de facto no-op, skipping the if block if one positional argument is provided. #
		{}

	# If 0 or >1 arguments are provided, print a brief help message and exit. #
	} else {
		printf( "\n%s\n\n", "USAGE: ./multi_to_single.awk input.fasta" )
		printf( "%-9s%s\n", "", "where:" )
		printf( "%-16s%20-s%s\n\n", "", "input.fasta", "a standard multi-line FASTA file" )

		EXITFLAG = 1
		exit 1
	}
}

# If the current record is a header, print it to a new line. #
/^>/ {
	if ( NR == 1 ) {
		printf( "%s\n", $0 )

	} else {
		printf( "\n%s\n", $0 )
	}
	next
}

# Append all sequences following the header to the following line until a new header is found. #
!/^>/ {
	printf( "%s", $0 )
}

# For a cleaner output, print a newline after all records have been processed. #
END {
	# If we exited in the BEGIN block, ensure we exit early in the END block. #
	if ( EXITFLAG ) { exit 1 }

	printf( "\n" )
}

