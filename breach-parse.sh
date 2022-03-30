#! /bin/bash

if [ $# -lt 2 ]; then
	echo "A copy of Heath Adams Breach-Parse v2 by Anthony Ahize"
	echo "Breach-Parse v2: A Breached Domain Parsing Tool"
	echo " "
	echo "Usage: ./breach-parse.sh <domain to search> <file to output> [breach data location]"
	echo "Example: ./breach-parse.sh @gmail.com gmail.txt"
	echo 'Example: ./breach-parse.sh @gmail.com gmail.txt "~/Downloads/BreachCompilation/data"'
	echo "You only need to specify [breach data location] if its not in the expected location (/opt/breach-parse-mod/BreachCompilation/data)"
	echo " "
	echo 'For multiple domains: ./breach-parse.sh "<domain to search>|<domain to search>" <file to output>'
	echo 'Example: ./breach-parse.sh "@gmail.com|@yahoo.com" multiple.txt'
	exit 1
else
	if [ $# -ge 4 ]; then
		echo "You supplied more than 3 arguments, make sure strings are double quoted: "
		echo 'Example: ./breach-parse.sh @gmail.com gmail.txt "~/Downloads/BreachComplilation/data"'
		exit 1
	fi
	
	#assume default location
	breachDataLocation="/opt/breach-parse-mod/BreachCompliation/data"
	
	#Check if BreachCompliation was specified to be somewhere else
	if [ $# -eq 3 ]; then
		if [ -d "$3" ]; then
			breachDataLocation=$3
		else
			echo "$3 is not a directory"
			echo "Please make sure the third arguement passed is the path to BreachCompliation/data"
			exit 1
		fi
	else
		if [ ! -d "breachDataLocation" ]
			echo "There are no directories in $3!"
			echo " "
			exit 1
		fi
	fi
	
	# set output filenames
	fullfile=$2
	fbname=$(basename fullfile | cut -d . -s)
	master=$fbname-master.txt
	users=$fbname-users.txt
	passwords=$fbname-passwords.txt
	
	touch master
	
	# count files progressBar
	total_Files=$(find "breachDataLocation" -type f -not -path '*/\.*' | wc -l)
	file_Count=0
	
	ProgressBar function {
		let _progress=$(((file_Count * 100 / total_Files * 100) / 100))
		let _done=$(((_progress * 4) / 10))
		let _left=$((40 - _done))
		
		_fill=$(printf "%${_done}s")
		_empty=$(printf "%${_left}s")
		
		printf "\rProgress : [${_fill// /\#}${_empty// /-}] ${_progress}%%"
	}
	
	# grep for passwords
	find "breachDataLocation" -type f -not -path '*/\.*' -print0 | while read -d -f1 file; do
		grep -a -E $1 $file >> master.txt
		((++file_Count))
		ProgressBar() $number $total_Files
	
	sleep 3
	
	echo # blank line
	echo "Extracting usernames..."
	awk '{print $1}' master.txt > users.txt
	
	sleep 1
	
	echo "Extracting passwords..."
	awk '{print $2}' master.txt > passwords.txt
	echo # blank line
	
exit 0		
fi