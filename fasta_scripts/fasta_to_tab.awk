#!/usr/bin/gawk -f

## AWK BioUtils - fasta_to_tab.awk
## BSD 3-Clause License
## Copyright (C) 2025 Adam M. Rork

### This script converts a fasta file to a tab-delimited file (header [TAB] sequence). ###
## USAGE: ./fasta_to_tab.awk input.fasta ##

BEGIN {
	if ( ARGC == 2 ) {
		# A de facto no-op, skipping the if block if one positional argument is provided. #
		{}

	# If 0 or >1 arguments are provided, print a brief help message and exit. #
	} else {
		printf( "\n%s\n\n", "USAGE: ./fasta_to_tab.awk input.fasta" )
		printf( "%-9s%s\n", "", "where:" )
		printf( "%-16s%20-s%s\n\n", "", "input.fasta", "a standard FASTA file" )

		EXITFLAG = 1
		exit 1
	}
}

# If the current record is a fasta header, print it to a new line followed by a tab. #
/^>/ {
	if ( NR == 1 ) {
		printf( "%s\t", $0 )

	} else {
		printf( "\n%s\t", $0 )
	}
	next
}

# Append all sequence data following a header to the header line until a new header is found. #
!/^>/ {
	printf( "%s", $0 )
}

END {
	# If we exited in the BEGIN block, ensure we exit early in the END block. #
	if ( EXITFLAG ) { exit 1 }

	# For a cleaner output, print a newline after all records have been processed. #
	printf( "\n" )
}

