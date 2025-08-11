#!/bin/bash

#
# GIT-UPDATE
#
# Łukasz Korbel 2016
# lkorbel@tuta.io
#
# Convenience script - automatically pull all changes, rebase local changes on them then and push to remote repository.
#
# Support usage of ssh-agent for git server authentication. If you don't need that part just remove it.
#
# To install this file make symbolic link in /usr/bin directory:
#
#   sudo ln -s <path-to-script>/git-update.sh /usr/bin/git-update
#


# assuming ssh-agent is running
# if no identity added yet add default one (assuming that it is used by git)
ssh-add -l &> /dev/null
if [ $? -eq 1 ]; then
    ssh-add
fi

# pull and rebase then send local changes
git pull --rebase && git push

