#!/bin/bash

#
# CLANG-FORMAT-ALL
#
# Łukasz Korbel 2017 
# korbel85@gmail.com
# 
# Convenience script - apply clang-format to all cpp/h files 
# in current directory (including all subdirectories)
# Requires: clan-format


# Hint: regex expression can be adjusted to search only for specific names
find . -regextype awk -regex .[a-zA-Z/_]+.\(cpp\|h\) -exec clang-format -i '{}' \;
