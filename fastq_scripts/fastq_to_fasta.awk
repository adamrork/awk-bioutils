#!/usr/bin/gawk -f

## AWK BioUtils - fastq_to_fasta.awk
## BSD 3-Clause License
## Copyright (C) 2025 Adam M. Rork

### This script converts a fastq file to a fasta file. ###
## USAGE: ./fastq_to_fasta.awk input.fastq ##

BEGIN {
	if ( ARGC == 2 ) {
		# A de facto no-op, skipping the if block if one positional argument is provided. #
		{}

	# If 0 or >1 arguments are provided, print a brief help message and exit. #
	} else {
		printf( "\n%s\n\n", "USAGE: ./fastq_to_fasta.awk input.fastq" )
		printf( "%-9s%s\n", "", "where:" )
		printf( "%-16s%20-s%s\n\n", "", "input.fastq", "a standard FASTQ file" )

		exit 1
	}
}

# Print the first and second lines of each fastq entry, replacing all leading "@" characters with ">". #
{
	if ( NR % 4 == 1 ) {
		gsub( /^@/, ">", $0 )
		printf( "%s\n", $0 )

	} else if ( NR % 4 == 2 ) {
		printf( "%s\n", $0 )
	}
}

