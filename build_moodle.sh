#!/bin/bash

# $ ./build_moodle.sh 31 avado

deploydir=M$1\_$2
cp -r Backups/Moodle/ $deploydir
cp Deployment/alp-cm-projects/sites/"$2".json $deploydir/componentmgr.json
cd $deploydir
git checkout MOODLE\_$1\_STABLE
composer install
componentmgr refresh
count=1
while [ $count -ne 0 ]; do
    componentmgr install
    count=$?
done
cp ../config.php config.php
cd ..
echo -e "\nBuild is complete. Customise config.php, then start using your new Moodle.\n\n"
