#!/bin/bash

# Apply clang tidy checks as separate commits to all files in project
# Requires: bear, make, clang-tidy

CLANG_TIDY=run-clang-tidy-3.8.py
CLANG_FORMAT=clang-format-3.8
#skip any files in hidden directories (name starting with ".")
FILE_PATTERN="^((?!\.\w+)[\w\.]+\/{1})*\w+\.cpp$"
#list of check we want ot perform on code
CHECKS=(modernize-loop-convert modernize-make-unique modernize-redundant-void-arg modernize-replace-auto-ptr modernize-shrink-to-fit modernize-use-auto modernize-use-default modernize-use-nullptr modernize-use-override cppcoreguidelines-c-copy-assignment-signature cppcoreguidelines-pro-bounds-array-to-pointer-decay cppcoreguidelines-pro-bounds-constant-array-index cppcoreguidelines-pro-bounds-pointer-arithmetic cppcoreguidelines-pro-type-const-cast cppcoreguidelines-pro-type-cstyle-cast cppcoreguidelines-pro-type-reinterpret-cast cppcoreguidelines-pro-type-union-access cppcoreguidelines-pro-type-vararg readability-container-size-empty readability-function-size readability-identifier-naming readability-inconsistent-declaration-parameter-name readability-named-parameter readability-redundant-smartptr-get readability-redundant-string-cstr    readability-simplify-boolean-expr readability-uniqueptr-delete-release google-build-explicit-make-pair google-build-namespaces google-build-using-namespace google-explicit-constructor google-global-names-in-headers google-readability-casting    google-readability-namespace-comments google-runtime-int google-runtime-member-string-references google-runtime-memset   google-runtime-operator misc-argument-comment misc-assert-side-effect misc-assign-operator-signature misc-bool-pointer-implicit-conversion misc-definitions-in-headers misc-inaccurate-erase misc-inefficient-algorithm misc-macro-repeated-side-effects misc-move-const-arg misc-move-constructor-init misc-new-delete-overloads misc-noexcept-move-constructor misc-non-copyable-objects misc-sizeof-container misc-static-assert misc-string-integer-assignment misc-swapped-arguments misc-throw-by-value-catch-by-reference misc-undelegated-constructor misc-uniqueptr-reset-release misc-unused-alias-decls misc-unused-parameters misc-unused-raii misc-virtual-near-miss readability-else-after-return)

#DONE
# 
#POSSIBLE FORMAT PROBLEMS
#readability-else-after-return
#BREAKS BUILD:
#readability-braces-around-statements misc-macro-parentheses
#BETTER DONT AUTO_FIX
#cppcoreguidelines-pro-type-static-cast-downcast readability-implicit-bool-cast
#ANALYSIS (no auto fixes)
#clang-diagnostic-*,clang-analyzer-*,-clang-analyzer-alpha*

if [ -z $1 ]; then
    echo "Usage $0 PATH_TO_MAKEFILE"
    exit 1
fi

PROJECT=$1
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

#apply checks
for i in ${CHECKS[@]}; do
    echo "Applying $i checks..."
    $CLANG_TIDY -j $NPROC -checks=-*,$i -fix $FILE_PATTERN > /dev/null
    DIFFS=$(git diff)
    if [ -n "${DIFFS}" ]; then
        git $CLANG_FORMAT -f
        #make sure it still builds
        make -j $NPROC
        if [ $? -ne 0 ]; then
            echo "Build broken after changes, aborting on $i"
            exit 4
        fi
        git commit -a -m "Apply clang-tidy: $i"
        if [ $? -ne 0 ]; then
            echo "Could not commit the change, aborting on $i"
            exit 5
        fi    
    else
        echo "Nothing has changed"
    fi
done
