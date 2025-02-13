#!/usr/bin/gawk -f

## AWK BioUtils - split_fasta.awk
## BSD 3-Clause License
## Copyright (C) 2025 Adam M. Rork

### This script splits a multi-sequence fasta file into multiple single-sequence fasta files. ###
## USAGE: ./split_fasta.awk input.fasta ##

BEGIN {
	# Assign the input fasta file to a variable. #
	if ( ARGC == 2 ) {
		INPUT_FILE = ARGV[1]

	# If 0 or >1 arguments are provided, print a brief help message and exit. #
	} else {
		printf( "\n%s\n\n", "USAGE: ./split_fasta.awk input.fasta" )
		printf( "%-9s%s\n", "", "where:" )
		printf( "%-16s%20-s%s\n\n", "", "input.fasta", "a standard FASTA file" )

		exit 1
	}

	# Set a cap on how many new fasta files can be created for safety. #
	MAX_SEQUENCES = 5000

	# Count the number of sequences in the input fasta file. #
	while ( ( getline record < INPUT_FILE ) > 0 ) {
		if ( record ~ /^>/ ) {
			num_sequences++
		}
	}

	# If the number of sequences in the input file exceeds the cap, print an error message and exit. #
	if ( num_sequences > MAX_SEQUENCES ) {
		printf( "\n%s\n", "ERROR: " INPUT_FILE " contains " num_sequences " sequences!" )
		printf( "%-7s%s\n\n", "", "This exceeds the " MAX_SEQUENCES " sequences limit!" )
		exit 1

	# If the file has no lines beginning with ">", print an error message and exit. #
	} else if ( num_sequences == 0 ) {
		printf( "\n%s\n\n", "ERROR: Your file is not a valid FASTA file, as it contains no headers!" )
		exit 1
	}

	# Create an interactive prompt asking users to confirm they want to create new files. #
	# If necessary, this prompt may be circumvented by piping "YES" into the command via echo, etc. #
	printf( "\n%s\n", "WARNING: This will create " num_sequences " new fasta files at \"" ENVIRON["PWD"] "/\"." )
	printf( "%-9s%s\n", "", "Are you sure you would like to proceed?" )
	printf( "%-9s%s", "", "Please enter YES to continue or NO to exit: " )
	getline response < "-"

	if ( response == "YES" ) {
		printf( "\n%s\n\n", "User entered YES. Continuing..." )

	} else if ( response == "NO" ) {
		printf( "\n%s\n\n", "User entered NO. Exiting..." )
		exit 0

	} else {
		printf( "\n%s\n\n", "ERROR: User specified neither YES nor NO. Exiting..." )
		exit 1
	}

}

# If the current record is a fasta header, print it to a file named after it, sans any whitespaces. #
/^>/ {
	header = substr( $0, 2 )
	gsub( " ", "_", header )
	printf( "%s\n", $0 ) > header"_split.fasta"
	next
}

# Append all sequences following the header to the same file until a new header is found. #
!/^>/ {
	printf( "%s\n", $0 ) >> header"_split.fasta"
}

