#!/usr/bin/gawk -f

## AWK BioUtils - deinterleave_files.awk
## BSD 3-Clause License
## Copyright (C) 2025 Adam M. Rork

### This script deinterleaves one interleaved text file into two files, one N-record entry at a time. ###
## USAGE: ./deinterleave_files.awk input.txt lines_per_entry ##

BEGIN {
	# Assign the input file and lines per entry to variables. Then, quash the latter positional argument. #
	if ( ARGC == 3) {
		INPUT_FILE = ARGV[1]
		LINES = ARGV[2]

		ARGV[2] = ""

	# If <2 or >2 arguments are provided, print a brief help message and exit. #
	} else {
		printf( "\n%s\n\n", "USAGE: ./deinterleave_files.awk input.txt lines_per_entry" )
		printf( "%-9s%s\n", "", "where:" )
		printf( "%-16s%20-s%s\n", "", "input.txt", "a text file" )
		printf( "%-16s%20-s%s\n\n", "", "lines_per_entry", "number of lines constituting an entry" )

		exit 1
	}

	# Assign the lines per pair of entries to a variable to facilitate concise modulo arithmetic below. #
	pair_lines = ( LINES * 2 )

	# Extract filenames from paths so we have clean strings to name our output files after. #
	gsub(/.*\//, "", INPUT_FILE)
}

# Append the first set of N records to file A, the second set of N records to file B, and repeat. #
{
	if ( ( NR % pair_lines > 0 ) && ( NR % pair_lines <= LINES ) ) {
		printf( "%s\n", $0 ) >> "A_"INPUT_FILE

	} else {
		printf( "%s\n", $0 ) >> "B_"INPUT_FILE
	}
}

