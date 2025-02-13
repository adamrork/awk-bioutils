#!/usr/bin/gawk -f

## AWK BioUtils - find_and_replace.awk
## BSD 3-Clause License
## Copyright (C) 2025 Adam M. Rork

### This script finds and replaces all occurences of strings in a file with new strings from a key-value file. ###
## USAGE: ./find_and_replace.awk dictionary.txt input.txt ##

BEGIN {
	if ( ARGC == 3 ) {
		# A de facto no-op, skipping the if block if two positional arguments are provided. #
		{}

	# If <2 or >2 arguments are provided, print a brief help message and exit. #
	} else {
		printf( "\n%s\n\n", "USAGE: ./find_and_replace.awk dictionary.txt input.txt" )
		printf( "%-9s%s\n", "", "where:" )
		printf( "%-16s%20-s%s\n", "", "dictionary.txt", "a two-field text file (string_to_find [TAB] replacement)" )
		printf( "%-16s%20-s%s\n\n", "", "input.txt", "a text file" )

		exit 1
	}
}

# Create a key-value array from the dictionary file (keys in field 1, replacement values in field 2). #
NR == FNR {
	arr[$1] = $2
	next
}

# Replace all occurences of key strings in the input file with corresponding values from the array. #
{
	for ( key in arr )
		gsub( key, arr[key] )
		printf( "%s\n", $0 )
}

