#!/bin/bash

#
# FIND_IN_SVG
# Łukasz Korbel @ 2025
# lkorbel@tuta.io
#
# Find string provided as argument in any svg or svgz file in provided folder.
# If folder is omitted using current folder.
# Example":
#  find_in_svg 'id="ID-Im-looking-for"'
#

print_usage() {
  echo "FIND_IN_SVG"
  echo "Usage:"
  echo "$0 TEXT [FOLDER]"
  echo ""
  echo "Script will search FOLDER (or current directory) for any svg or svgz file "
  echo "and if a file contains given text than its path will be printed."
  exit 1
}

if [ -z $1 ]; then
  print_usage
fi

TEXT="${1}"
FOLDER=$2
if [ -z $2 ]; then
  FOLDER=$(pwd)
fi

# Check if file contains text - this function is run if script was invoked with special arguments
check_file() {
  FILEPATH=$1
  PATTERN=$2
  READER=cat
  if [[ "$FILEPATH" == *.svgz ]]; then
    READER="gzip -dc"
  fi
  $READER "$FILEPATH" | grep $PATTERN > /dev/null 2>&1
  exit $?
}

# We use special value for text to run script in special mode
# It is used to pass this script as action for find tool
if [ "$FOLDER" == "CHECKFILE" ]; then
  check_file ${3?} $TEXT
fi

echo "SVG files containing text: ${TEXT}"

# Search in svg and svgz files
find "${FOLDER}" -regex .*svgz* -type f -execdir $0 $TEXT CHECKFILE '{}' \; -print
