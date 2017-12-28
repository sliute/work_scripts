#!/bin/bash

# Run this script from inside your Projects folder, with two arguments, in this order:
# - Moodle stable version, without the period (e.g. 33 for Moodle 3.3)
# - campus name, as used in Bitbucket (e.g. avado, ufw)
#
# $ ./build_moodle.sh 31 avado

# Here is the directory structure that needs to be in place for this script to run properly.
# <currentdir> - e.g. Projects or Code
#  |-Backups/Moodle - a vanilla Moodle repo straight from GitHub, so you can check out any stable version you like.
#  |-Deployment/alp-cm-projects - the Component Manager project file repo
#  |-config.php - a sample config file (based on the one provided by Ubiquitous) that needs minimal customisation.

# Ensure only two arguments have been provided.
if [ "$#" -ne 2 ]; then
    echo -e "\nPlease provide two arguments: a two-digit Moodle version number (e.g. 33) and a project file name.\n"
    exit
fi

# Ensure first argument is a 2-digit integer.
if ! [[ "$1" =~ ^[0-9]{2}$ ]]; then
    echo -e "\nPlease make sure your first argument is a 2-digit positive integer (e.g. 29).\n"
    exit
fi

# Exit with non-zero code if named project file does not exist.
if ! [ -f Deployment/alp-cm-projects/sites/"$2".json ]; then
    echo -e "\nFailure: no '$2' project file exists in alp-cm-projects/sites. Please review/update that folder and try again.\n"
    exit 2
fi

# Create deployment directory, then copy plain Moodle and chosen project file there.
deploydir=M$1\_$2\_$(date +%Y%m%d)
cp -r Backups/Moodle/ $deploydir
cp Deployment/alp-cm-projects/sites/"$2".json $deploydir/componentmgr.json
cd $deploydir

# Check out the desired Moodle version and exit if it does not exist.
git checkout MOODLE\_$1\_STABLE
if [ $? -ne 0 ]; then
    verno=$(echo "scale=1;$1/10" | bc)
    echo -e "\nFailure: Moodle has no $verno stable version. Please retry with an existing version number.\n"
    exit 3
fi

# Run composer install
composer install

# Run componentmgr install and retry if it has failed (mostly due to timeout errors, all hail Bitbucket!)
componentmgr refresh
count=1
while [ $count -ne 0 ]; do
    componentmgr install
    count=$?
done

# Copy the standard config.php file, i.e. the one provided in the Ubiquitous documentation.
cp ../config.php config.php
cd ..
echo -e "\nThis build is complete. Please customise config.php, then start using your new Moodle.\n"
