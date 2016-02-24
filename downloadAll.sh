#!/bin/bash -eu

echo "*** Download files from SCG3 ***"

if [ $# -lt 3 ]
then 
	echo "Usage: $0 <file with scg3 locations; one file per line> <scg3 username> <output directory>"
	exit 1
fi

input_file=$1;
user=$2;
out_directory=$3;

USER_AT_HOST="$user@crick.stanford.edu"
SSHSOCKET=~/".ssh/$USER_AT_HOST"

# This is the only time you have to enter the password:
# Open master connection:
ssh -M -f -N -o ControlPath="$SSHSOCKET" "$USER_AT_HOST"

#Loop through file and download each file
LINES=`cat $input_file`
for line in $LINES; do
	file_name=`basename $line`
	echo "Downloading $file_name"
	scp -o ControlPath="$SSHSOCKET" "$USER_AT_HOST":"$line" "$out_directory"/"$file_name"
done

ssh -S "$SSHSOCKET" -O exit "$USER_AT_HOST"