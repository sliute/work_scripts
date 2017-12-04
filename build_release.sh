#!/bin/bash

# Run this script from inside your Deployments folder, with two arguments, in this order:
# - campus name, as used in Bitbucket (e.g. avado, ufw)
# - release number (e.g. 17).
#
# $ ./build_release.sh avado 17

# Create sub-folder structure if it doesn't already exist.
# Pull project files repository from Bitbucket if needed.
#
# <currentdir>
#  |-alp-cm-projects
#  |-releases
#  |-tmp

DIRS=(releases tmp)
for dir in "$DIRS"
do
    if ! [ -d "$dir" ]; then
        mkdir "$dir"
    fi
done

# Always have an up-to-date project repository.

if ! [ -d alp-cm-projects ]; then
    git clone git@bitbucket.org:avadolearning/alp-cm-projects.git
    if [ $? -eq 0 ]; then
        cd alp-cm-projects
    else
        echo -e "\nFailure: could not clone the project repository.\nPlease make sure you can access it.\n"
        exit
    fi
else
    cd alp-cm-projects
    git fetch && git reset --hard origin/master
    if [ $? -ne 0 ]; then
        echo -e "\nFailure: could not update the project repository.\nPlease make sure you can access it."
        exit
    fi
fi

# Execute operations.

if ! [ -e ./sites/"$1".json ]; then
    echo -e "\nFailure: the named project file does not exist.\nPlease check spelling and retry.\n"
    exit
fi

# Package a new release with Component Manager.
componentmgr --verbose refresh --project-file ./sites/"$1".json && componentmgr --verbose package --project-file ./sites/"$1".json --package-format ZipArchive --package-destination ../tmp/"$(date +%Y%m%d)"-"$1".zip

if [ $? -ne 0 ]; then
    echo -e "\nFailure: Component Manager operations have failed.\nPlease check the content of your project file and your internet connectivity, then retry."
    exit
fi

# Clone the campus from Bitbucket, if it does not exist in the local releases folder.
if ! [ -d ../releases/"$1" ]; then
	cd ../releases
	git clone git@bitbucket.org:avadolearning/"$1".git
    if [ $? -eq 0 ]; then
        cd "$1"
    else
        echo -e "\nFailure: could not clone the campus repository.\nPlease make sure you can access it.\n"
        exit
    fi
else
	cd ../releases/"$1"
fi

# Put the new release in the campus and return to alp-cm-projects folder.
git fetch && git reset --hard origin/master
if [ $? -ne 0 ]; then
    echo -e "\nFailure: could not update the campus repository.\nPlease make sure you can access it."
    exit
fi
git clean -fdx
find . ! -path './.git*' -type f -exec git rm {} +
unzip -o ../../tmp/"$(date +%Y%m%d)"-"$1".zip
find . -name .gitignore -delete
git add .
git commit -m "ALP SP$(date +%Y).$2 release"
cd ../../alp-cm-projects

# Post completion message to console. 
echo -e "\nSuccess: This deployment script has completed.\nNow go into the $1 campus folder, check the log and cherry-pick as needed.\n"

