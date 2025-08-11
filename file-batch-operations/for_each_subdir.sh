#!/bin/bash

# List all subdirectories in current directory.
# For each subdirectory execute code passed in command line as ACTION
# ACTION will use subdirectory name,
# which is passed without backslash as $1 argument.
# If FILTER string was provided it will be appended to dir name.
# Using filter allow to create path patterns and run ACTION in every subdir
# only for files matching path.
# FILTER must start with / (slash).
# script accepts up to 2 extra options for ACTION to be passed.
# Make sure arguments you pass make sense for your ACTION. Script is dumb.

if [ -z $1 ]; then
    echo "Usage: ${0} [FILTER] ACTION [EXTRA_ARG1 EXTRA_ARG2]"
    echo ""
    echo "FILTER - string starting with / that will be append to dir name"
    echo "ACTION - program to be called on each subdir"
    echo "EXTRA_ARG1 - extra argument for ACTION (optional)"
    echo "EXTRA_ARG2 - extra argument for ACTION (optional)"
    echo ""
    echo "Script will run on all subdirectorties of the current directory!"
    exit 1
else
	if  [[ "${1:0:1}" == "/" ]]; then
        FILTER=$1
		ACTION=${2?}
		EXTRA1=$3
		EXTRA2=$4
	else
                ACTION=$1
		EXTRA1=$2
		EXTRA2=$3
	fi
fi

# If action is a file, assume its script and source it
if [ -e $ACTION ]; then
    EXEC=source
fi

SAVEIFS=$IFS
IFS=$(echo -en "\n\b")
for d in */
do #execute action with dir name and extra params
    if [ -d $d ]; then #if its a dir
        DIR=${d:0:$(expr ${#d} - 1)}
	echo " - ${DIR}"
	$EXEC $ACTION $DIR$FILTER $EXTRA1 $EXTRA2
    fi
done
IFS=$SAVEIFS
