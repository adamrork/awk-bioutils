#!/usr/bin/gawk -f

## AWK BioUtils - condense_columns.awk
## BSD 3-Clause License
## Copyright (C) 2025 Adam M. Rork

### This script converts a multi-field (wide) file to a two-field (long) file. ###
## USAGE: ./condense_columns.awk wide_input.txt "in_keyval_dlm" "in_valval_dlm" "out_keyval_dlm" ##

BEGIN {
	# Assign the key-val and val-val delimiters to variables. Then, quash the positional arguments. #
	if ( ARGC == 5 ) {
		IN_KV = ARGV[2]
		IN_VV = ARGV[3]
		OUT_KV = ARGV[4]

		ARGV[2] = ""
		ARGV[3] = ""
		ARGV[4] = ""

	# If <4 or >4 arguments are provided, print a brief help message and exit. #
	} else {
		printf( "\n%s\n\n", "USAGE: ./condense_columns.awk input.txt \"in_keyval_dlm\" \"in_valval_dlm\" \"out_keyval_dlm\"" )
		printf( "%-9s%s\n", "", "where:" )
		printf( "%-16s%20-s%s\n", "", "input.txt", "a multi-field text file" )
		printf( "%-16s%20-s%s\n", "", "in_keyval_dlm", "the input key-value delimiter, in quotes" )
		printf( "%-16s%20-s%s\n", "", "in_valval_dlm", "the input value-value delimiter, in quotes" )
		printf( "%-16s%20-s%s\n\n", "", "out_keyval_dlm", "the output key-value delimiter, in quotes" )

		exit 1
	}

	# Tabs are likely the only common delimiter that needs special handling. #
	if ( IN_KV == "\\t" ) { IN_KV = "\t" }
	if ( IN_VV == "\\t" ) { IN_VV = "\t" }
	if ( OUT_KV == "\\t" ) { OUT_KV = "\t" }

	# Define the input and output field separators. #
	FS = IN_KV
	OFS = OUT_KV
}

{
	# Enforce delimiter consistency across all fields to ensure proper parsing. #
	if ( IN_KV != IN_VV ) {
		gsub( IN_VV, IN_KV, $0 )
	}

	# For each key and associated value, regenerate key-val pairs, one key and one value per record. #
	for ( val = 2; val <= NF; val++ )
		print( $1, $val )
}

