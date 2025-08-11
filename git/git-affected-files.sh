#!/bin/bash

# GIT-AFFECTED-FILES
# Łukasz Korbel 2025
# lkorbel@ tuta.io

# List all files from repo that were modified in any commit in which first line of message match grep filter passed as $1
# Useful when you need to check what files were changed by wider amount of commits that are somehow related.
COMMIT_PATTERN=${"1?"}

# regex for file path in git msg
# pattern is: "^\s*[\w/]+\.\w+"
RGX_PATH="^[[:space:]]*[[:alpha:]/]+\.[[:alpha:]]+"

git log --oneline --grep "${COMMIT_PATTERN}" --stat | grep -o -E "$RGX_PATH"

