#!/usr/bin/gawk -f

## AWK BioUtils - interleave_files.awk
## BSD 3-Clause License
## Copyright (C) 2025 Adam M. Rork

### This script interleaves two text files, one N-record entry at a time. ###
## USAGE: ./interleave_files.awk input_A.txt input_B.txt lines_per_entry ##

BEGIN {
	# Assign the second input file and the lines-per-entry to variables. Then, quash the positional arguments. #
	if ( ARGC == 4 ) {
		INPUT_FILE_B = ARGV[2]
		LINES = ARGV[3]

		ARGV[2] = ""
		ARGV[3] = ""

	# If <3 or >3 arguments are provided, print a brief help message and exit. #
	} else {
		printf( "\n%s\n\n", "USAGE: ./interleave_files.awk input_A.txt input_B.txt lines_per_entry" )
		printf( "%-9s%s\n", "", "where:" )
		printf( "%-16s%20-s%s\n", "", "input_A.txt", "a text file" )
		printf( "%-16s%20-s%s\n", "", "input_B.txt", "a text file" )
		printf( "%-16s%20-s%s\n\n", "", "lines_per_entry", "number of lines constituting an entry in each file" )

		exit 1
	}
}

# Print an entry of input_file_A. #
{
	# Print the nth record of file_A explicitly, since this file is parsed normally. #
	printf( "%s\n", $0 )

	# Continue printing records of file_A until a total of LINES records have been printed. #
	for ( line = 1; line <= ( LINES - 1 ); line++ ) {
		if ( getline record > 0 ) {
			printf( "%s\n", record )

		# If there is any issue parsing file_A, print a brief error message and exit. #
		} else {
			printf( "\n%s\n\n", "ERROR: Could not parse " INPUT_FILE_A " properly!" )
			exit 1
		}
	}
}

# Print the corresponding entry of input_file_B. Then, restart with the next entries of file_A and file_B. #
{
	# Print records of file_B until a total of LINES records have been printed. #
	for ( line = 1; line <= LINES; line++ ) {
		if ( ( getline record < INPUT_FILE_B ) > 0 ) {
			printf( "%s\n", record )

		# If there is any issue parsing file_B, print a brief error message and exit. #
		} else {
			printf( "\n%s\n\n", "ERROR: Could not parse " INPUT_FILE_B " properly!" )
			exit 1
		}
	}
}

