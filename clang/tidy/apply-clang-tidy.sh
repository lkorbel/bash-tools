#!/bin/bash

#
# APPLY-CLANG-TIDY
# Łukasz Korbel @ 2020
# lkorbel@ tuta.io
#
# Apply clang tidy checks as separate commits to all files in project.
# Project must be a cmake project (contains CMakeLists.txt) and be configured as git repository.
# File containing list of desired clang checks must be located inside project directory. This is simple text file where each line is name of a check recognized by clang-tidy - reffer to example files all-checks.txt and qt-friendly-checks.txt
# Requires: bear, make, clang-tidy
# Script is using require.sh from this repository that must be installed in path without suffix.

require make git clang-tidy bear || exit 1

CLANG_TIDY=run-clang-tidy
#skip any files in hidden directories (names starting with ".")
FILE_PATTERN="^(?!.*builds\/moc\/).*\.(h|cpp)$"
#by extension only: ".*\.(h|cpp)"
# old pattern: "^((?!\.\w+)[\w\.]+\/{1})*\w+\.cpp$"


print_usage() {
echo "Usage $0 PATH_TO_MAKEFILE FILE_WITH_CHEKS_LIST"
}

log_to() {
file=$1
awk '{if (match($0, "^clang-tidy")) next; else print $0}' log.temp >> $file
}


if [ -z $1 ]; then
    print_usage
    exit 1
fi
PROJECT=$1

if [ -z $2 ]; then
    print_usage
    exit 2
fi
CHECKS=$2

if [ ! -e "$PROJECT/$CHECKS" ]; then
    echo "Wrong path to CHECKS file"
    exit 3
fi

cd $PROJECT
NPROC=$(nproc)


#build compile commands database if needed
if [ ! -e compile_commands.json ]; then
    if [ ! -e Makefile ]; then
        echo "No makefile under directory: $PROJECT"
        exit 2;
    fi
    make clean
    bear make -j $NPROC
else
    echo "compile_commands.json already build, remove it if you need to update database"
fi

# apply all checks from file
for i in $(cat $CHECKS); do
    echo "Applying $i checks..."
    $CLANG_TIDY -j $NPROC -checks=-*,$i -quiet -fix $FILE_PATTERN  > log.temp 2> /dev/null
    # check if there are any changes
    DIFFS=$(git diff)
    if [ -n "${DIFFS}" ]; then
        # make sure it still builds
        make -j $NPROC > /dev/null 2>&1
        if [ $? -ne 0 ]; then
            echo "Build broken after changes, aborting on $i"
            git reset --hard
            log_to failed.log
        else
            git commit --no-verify -a -m "Apply clang-tidy: $i"
            if [ $? -ne 0 ]; then
                echo "Could not commit the change, aborting on $i"
                exit 5
            fi
            log_to fixed.log
        fi
    else
        echo "Nothing has changed"
        log_to apply-clang-format.log
    fi
done
