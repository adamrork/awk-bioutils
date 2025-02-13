#!/usr/bin/gawk -f

## AWK BioUtils - expand_columns.awk
## BSD 3-Clause License
## Copyright (C) 2025 Adam M. Rork

### This script converts a two-field (long) file to a multi-field (wide) file. ###
## USAGE: ./expand_columns.awk input.txt "in_keyval_dlm" "out_keyval_dlm" "out_valval_dlm" ##

BEGIN {
	# Assign the key-val and val-val delimiters to variables. Then, quash the positional arguments. #
	if ( ARGC == 5 ) {
		IN_KV = ARGV[2]
		OUT_KV = ARGV[3]
		OUT_VV = ARGV[4]

		ARGV[2] = ""
		ARGV[3] = ""
		ARGV[4] = ""

	# If <4 or >4 arguments are provided, print a brief help message and exit. #
	} else {
		printf( "\n%s\n\n", "USAGE: ./expand_columns.awk input.txt \"in_keyval_dlm\" \"out_keyval_dlm\" \"out_valval_dlm\"" )
		printf( "%-9s%s\n", "", "where:" )
		printf( "%-16s%20-s%s\n", "", "input.txt", "a two-field text file" )
		printf( "%-16s%20-s%s\n", "", "in_keyval_dlm", "the input key-value delimiter, in quotes" )
		printf( "%-16s%20-s%s\n", "", "out_keyval_dlm", "the output key-value delimiter, in quotes" )
		printf( "%-16s%20-s%s\n\n", "", "out_valval_dlm", "the output value-value delimiter, in quotes" )

		EXITFLAG = 1
		exit 1
	}

	# Tabs are likely the only common delimiter that needs special handling. #
	if ( IN_KV == "\\t" ) { IN_KV = "\t" }
	if ( OUT_KV == "\\t" ) { OUT_KV = "\t" }
	if ( OUT_VV == "\\t" ) { OUT_VV = "\t" }

	# Define the input and output field separators. #
	FS = IN_KV
	OFS = ""
}

{
	# If processing a new key, assign it to the array followed by a key-val delimiter and its value. #
	if ( length( arr[$1] ) == 0 ) {
		arr[$1] = arr[$1] OUT_KV $2

	# If processing the same key, append a val-val delimiter and the new value to the previous value. #
	} else if ( length ( arr[$1] ) > 0 ) {
		arr[$1] = arr[$1] OUT_VV $2
	}
}

END {
	# If we exited in the BEGIN block, ensure we exit early in the END block. #
	if ( EXITFLAG ) { exit 1 }

	# Once the array is populated, print each key-val set pair within it. #
	for ( key in arr ) {
		print( key, arr[key] )
	}
}

