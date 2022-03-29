#! /bin/bash

if [ $# -lt 2 ]; then
	echo "Please pass in at least 3 arguments"
	exit 1
else
	if [ $# -ge 4 ]; then
		echo "You supplied more than 3 arguments, make sure strings are double quoted: "
		echo "#some more text"
		exit 1
	fi
	
	#assume default location
	breachDataLocation="/opt/breach-parse-mod/BreachCompliation/data"
	
	#Check if BreachCompliation was specified to be somewhere else
	if [ $# -eq 3 ]; then
		