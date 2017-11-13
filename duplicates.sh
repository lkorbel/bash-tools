#!/bin/sh 
# 
# DUPLICATES SEARCH TOOL
# korbel85@gmail.com 
#

if [ -z "$2" ]; then
    echo "File duplicates search tool 1.0\n"
    echo "Usage:"
    echo "$0 PATTERN DIRS\n"
    echo "PATTERN - regular expression file pattern as given to find -regex"
    echo "DIRS - space-separated list of directories to be searched e.g. \"dir1 dir2\""
    echo "Search for files matching PATTERN in given DIRS and print file names that are duplicated"
    exit 1
fi

PATTERN=$1
DIRS=$2
FOUND=""

for i in $DIRS; do
    find $i -regex $PATTERN -fprintf $i.files %f:\\t%p\\n
    FOUND="$FOUND $i.files"
done

name=""
prev_name=""
read_name=1
read_path=0
duplicate=0

for line in $(cat $FOUND | sort); do

    if [ $read_name -eq 1 ]; then
        if [ $duplicate -eq 0 ]; then
            prev_name=$name 
        fi
        name=$line
        if [ "$name" = "$prev_name" ]; then
            duplicate=1
        else
            if [ $duplicate -eq 1 ]; then
                duplicate=2
            else
                duplicate=0
            fi
        fi
        read_name=0
        read_path=1
        continue
    fi
    
    if [ $read_path -eq 1 ]; then
        if [ $duplicate -eq 0 ]; then
            paths=$line
        fi
        if [ $duplicate -eq 1 ]; then
            paths="$paths $line"
        fi
        if [ $duplicate -eq 2 ]; then
            echo "Duplicated $prev_name"
            for p in $paths; do
                echo "* $p"
            done
            paths=""
        fi
        read_name=1
        read_path=0
        continue
    fi
    
    echo "PARSING ERROR!"
done

rm $FOUND