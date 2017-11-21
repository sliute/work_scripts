#!/bin/bash


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
	cd alp-cm-projects
else
	cd alp-cm-projects
	git fetch
	git reset --hard origin/master
fi

# Execute operations for each campus (name provided as parameter to this script).

DATE="$(date +%Y%m%d)"

for i in "$@"
do
	# Package a new release with Component Manager
	componentmgr --verbose refresh --project-file ./sites/"$i".json
	componentmgr --verbose package --project-file ./sites/"$i".json --package-format ZipArchive --package-destination ../tmp/"$DATE"-"$i".zip

	# Clone the campus from Bitbucket, if it does not exist in the local releases folder.
	if ! [ -d ../releases/"$i" ]; then
		cd ../releases
		git clone git@bitbucket.org:avadolearning/"$i".git
		cd "$i"	
	else
		cd ../releases/"$i"
	fi

	# Put the new release in the campus and return to alp-cm-projects.
	git fetch
	git reset --hard origin/master
	git clean -fdx
	find . ! -path './.git*' -type f -exec git rm {} +
	unzip -o ../../tmp/"$DATE"-"$i".zip
	find . -name .gitignore -delete
	git add .
	cd ../../alp-cm-projects
done


# Post completion message to console. 

echo -e "\nDeployment script is complete.\nNow go into each release folder and commit with 'ALP SP2017.XX release'.\n"

