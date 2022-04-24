#!/bin/bash

#
# GIT-UPDATE
#
# Łukasz Korbel 2016
# korbel85@gmail.com
#
# Convenience script - automatically pull all changes, rebase local changes on them then and push to remote repository.

# Support usage of ssh-agent for git server authentication.
# To install this file make symbolic link in /usr/bin directory:
#
#   ln -s <path-to-script>/git-update.sh /usr/bin
#


#assuming ssh-agent is running
#if no identity added yet add default one (assuming that it is used by git)
ssh-add -l &> /dev/null
if [ $? -eq 1 ]; then
    ssh-add
fi

# pull and rebase then send local changes
git pull --rebase && git push

