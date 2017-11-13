#!/bin/bash

#
# GIT-UPDATE
#
# Łukasz Korbel 2016
# korbel85@gmail.com
#
# Convenience script - automatically pull all changes and push local changes on server.
# if any of local commit messages cotnain phrase: <rebase-me> push is not executed.
# Run post-pull hook if its available in .git/hooks post-pull script is not a git hook
# but it behaves one. It will be called with old HEAD sha as argument.
# Support usage of ssh-agent for git server authentication.
# To install this file make symbolic link in /usr/bin directory:
#
#   ln -s git-update.sh /usr/bin
#


#assuming ssh-agent is running
#if no identity added yet add default one (assuming that it is used by git)
ssh-add -l &> /dev/null
if [ $? -eq 1 ]; then
    ssh-add
fi

#Check if we are in repo and what is the last commit
ROOT=$(git rev-parse --show-toplevel)
if [ $? -ne 0 ];
    then exit 1;
fi
OLD_HEAD=$(git rev-parse HEAD)

git pull --rebase


#run post-pull hook (this is not part of git)
POST_PULL=$ROOT/.git/hooks/post-pull
if [ -x $POST_PULL ]; then
    $POST_PULL $OLD_HEAD;
fi

#dont push if local commit contains word "rebase me"
git log | grep "<rebase-me>" &> /dev/null
if [ $? -eq 1 ]; then
    git push
else
    echo "You have changes that wait for local rebase"
fi

