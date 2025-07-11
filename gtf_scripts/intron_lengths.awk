#!/usr/bin/gawk -f

## AWK BioUtils - intron_lengths.awk
## BSD 3-Clause License
## Copyright (C) 2025 Adam M. Rork

### This script generates a distribution of intron lengths from a GTF file. ###
## USAGE: ./intron_lengths.awk input.gtf ##

BEGIN {
	if ( ARGC == 2 ) {
		# A de facto no-op, skipping the if block if one positional argument is provided. #
		{}

	# If 0 or >1 arguments are provided, print a brief help message and exit. #
	} else {
		printf( "\n%s\n\n", "USAGE: ./intron_lengths.awk input.gtf" )
		printf( "%-9s%s\n", "", "where:" )
		printf( "%-16s%20-s%s\n\n", "", "input.gtf", "a standard GTF file" )

		EXITFLAG = 1
		exit 1
	}

	# Define the output field separator. #
	OFS = "\t"

	# Initialize some variables to empty strings. #
	exon_5prime = ""
	exon_3prime = ""
	stored_exon_3prime = ""

	current_transcript = ""
	previous_transcript = ""
}

# Calculate intron lengths from "+" strand transcripts. #
$3 == "exon" && $7 ~ "+" {

	# Assign exon 5-prime and exon 3-prime coordinates and the current transcript to variables. #
	exon_5prime = $4
	exon_3prime = $5
	current_transcript = $12

	# Within a transcript, calculate and assign the length between adjacent exons (i.e., the intron length) to an array. #
	if ( current_transcript == previous_transcript ) {
		arr[exon_5prime - stored_exon_3prime - 1]++
	}

	# Store our current exon 3-prime coordinate for use in the next iteration and update which transcript we are within. #
	stored_exon_3prime = exon_3prime
	previous_transcript = current_transcript

	next
}

# Calculate intron lengths from "-" strand transcripts. #
$3 == "exon" && $7 ~ "-" {

	# Logic is as above. #
	exon_5prime = $5
	exon_3prime = $4
	current_transcript = $12

	# Logic is as above. #
	if ( current_transcript == previous_transcript ) {
		arr[stored_exon_3prime - exon_5prime - 1]++
	}

	# Logic is as above. #
	stored_exon_3prime = exon_3prime
	previous_transcript = current_transcript
}

END {
	# If we exited in the BEGIN block, ensure we exit early in the END block. #
	if ( EXITFLAG ) { exit 1 }

	# Print a sorted table of intron lengths (col 1) and the number of occurences of each (col 2). #
	PROCINFO["sorted_in"] = "@ind_num_asc"

	for ( len in arr ) {
		print( len, arr[len] )
	}
}

