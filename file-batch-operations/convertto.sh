#!/bin/bash

# convert all files from given folder to given extension
# Folder name must be passed as first command-line argument
# desired format must be passed as 2nd argument
#assuming that all files are images
FOLDER=${1?}
EXT=${2?}

mogrify -format $EXT "${FOLDER}/*"

