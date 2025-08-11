#!/bin/bash

# Simply print the count of files in a FOLDER.
# Folder name must be passed as first command-line argument
FOLDER=${1?}
COUNT=$(ls "${FOLDER}" | wc -l)
echo "${COUNT} files."
