#!/bin/bash
# A script to start our standard Ubiquitous setup:
# salt, app, db, selenium-hub, and selenium-node-chrome.
# Add further VM names as CLI arguments to add them to the up sequence.

VMS=(salt db-pgsql-1 app-debug-1 app-debug-2 selenium-hub selenium-node-chrome)

for arg in "$@"
do
	VMS+=("$arg")
done

errors=0

for i in "${VMS[@]}"
do
	vagrant up "$i" && vagrant ssh --command 'sudo salt '"$i"' state.apply'
	if [ $? -ne 0 ]; then
	    errors=$((errors+1))
	fi
done

if [ $errors -eq 0 ]; then
    echo -e "\nAll virtual machines are up and states have been applied. You are free to proceed.\n"
else
    echo -e "\n"$errors" virtual machine states have not been applied. Blame the lazy minions and re-run this script to fix the problem.\n"
fi
