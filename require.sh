#!/bin/bash

#
# REQUIRE - convenience tool for checking if required programs are installed
#
# Łukasz Korbel @ 2025
# lkorbel@tuta.io
#
# This tool is intented for usage in other scripts. Provide all required programs as arguments.
# Tool will iterare through all of them. If something is not installed it will print a warning.
# Return: number of programs that are missing
#
# Example of usage in a script:
#
# require git clang-format curl || exit 1
#
# You can use the script from any place. If you like syntax like above to work make symbolic link to usr/bin:
#
#    sudo ln -s <path-to-script>/require.sh /usr/bin/require
#

MISSING=0
for PROGRAM in "${@}"; do
  if ! command -v $PROGRAM > /dev/null 2>&1; then
    MISSING=$(($MISSING + 1))
    echo "${PROGRAM} is not installed."
  fi
done
exit $MISSING
