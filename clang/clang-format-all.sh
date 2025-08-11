#!/bin/bash

#
# CLANG-FORMAT-ALL
#
# Łukasz Korbel 2017
# lkorbel85@tuta.io
#
# Convenience script - apply clang-format to all cpp/h files in current directory (including all subdirectories).
# Might be useful if you want ot start using clang format on existing project.
# Requires: clang-format
# Script is using require.sh from this repo that must be install in path without suffix (as "require")

require clang-format || exit 1
# Hint: regex expression can be adjusted to search only for specific names
find . -regextype awk -regex .[a-zA-Z/_]+.\(cpp\|h\) -exec clang-format -i '{}' \;
