#!/bin/bash
# A script that pulls a repo from our Bitbucket, stores it
# in a properly-named folder and checks out the desired branch.
# Only works if you already have access to our Bitbucket account.
#
# E.g.: $ ./gimme.sh repo_name [branch], as in $ ./gimme.sh theme_hlc ALP-1247
# If no branch is provided, then it all defaults to 'master'

if [ "$#" -lt 1 ]; then
    echo -e "\nFailure: You must provide at least the repo name. Optionally, you can also provide a non-master branch name.\n"
    exit
fi

args=( "$@" )
repo=${args[0]}
foldername=$(echo $repo | cut -d'_' -f2)

if [ "$#" -eq 1 ]; then
    branch='master'
else
    branch=${args[1]}
fi

git clone git@bitbucket.org:avadolearning/$repo $foldername 
if [ $? -ne 0 ]; then
    echo -e "\nFailure: Most likely, the repo name you provided does not exist. Please check the stack trace above and retry.\n"
    exit
fi

cd $foldername
git checkout $branch
if [ $? -ne 0 ]; then
    echo -e "\nFailure: git operations have failed. Please check the stack trace above and retry.\n"
    exit
fi

echo -e "\nSuccess: The $repo repository is now available in the $foldername folder, and its current branch is $branch.\n"

