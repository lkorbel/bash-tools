#!/bin/bash

# convert all jpg from given folder to pdf with name of a folder
# Folder name must be passed as first command-line argument
FOLDER=${1?}

convert "${FOLDER}/*.jpg" "${FOLDER}.pdf"

