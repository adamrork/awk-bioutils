#!/usr/bin/gawk -f

## AWK BioUtils - gtf_to_bed6.awk
## BSD 3-Clause License
## Copyright (C) 2025 Adam M. Rork

### This script converts a GTF file to a BED6 file. ###
## USAGE: ./gtf_to_bed6.awk input.gtf ##

BEGIN {
	if ( ARGC == 2 ) {
		# A de facto no-op, skipping the if block if one positional argument is provided. #
		{}

	# If 0 or >1 arguments are provided, print a brief help message and exit. #
	} else {
		printf( "\n%s\n\n", "USAGE: ./gtf_to_bed6.awk input.gtf" )
		printf( "%-9s%s\n", "", "where:" )
		printf( "%-16s%20-s%s\n\n", "", "input.gtf", "a standard GTF file" )

		exit 1
	}

	# Define the output field separator. #
	OFS = "\t"
}

# From each transcript entry in the GTF, extract the fields corresponding to BED6 format. #
# 1 = chrom  | 2 = [chrom] start*  | 3 = [chrom] end*                                     #
# 4 = name   | 5 = score*          | 6 = strand*                                          #

# In BED, chrom start is 0-indexed. In GTF it is 1-indexed, so we subtract 1 from each GTF chrom start. #
# In both BED and GTF, chrom end is 1-indexed, so unlike chrom start we leave that value as-is. #
# The score can be any string, but there is no score data to extract from GTF, so we will use 0 here. #
# According to UCSC, undefined strands should be represented by ".", so we will enforce that here. #

!/^#/ {
	# BED file rows correspond to GTF transcript rows. Also, clean up the rows. #
	if ( $3 == "transcript" ) {
		gsub( /\"/, "", $0 )
		gsub( /\;/, "", $0 )

		# Extract data for entries with "+" or "-" strand characters as outlined above. #
		if ( $7 == "+" || $7 == "-" ) {
			print( $1, ( $4 - 1 ), $5, $12, 0, $7 )

		# Where necessary, also replace non-"+" and non-"-" strand characters with "." as per UCSC. #
		} else {
			print( $1, ( $4 - 1 ), $5, $12, 0, "." )
		}
	}
}

