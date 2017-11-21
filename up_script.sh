#!/bin/bash
# A script to start our standard Ubiquitous setup:
# salt, app, db, selenium-hub, and selenium-node-chrome.
# Add further VM names as CLI arguments to add them to the up sequence.

VMS=(salt db-pgsql-1 app-debug-1 app-debug-2 selenium-hub selenium-node-chrome)

for arg in "$@"
do
	VMS+=("$arg")
done

for i in "${VMS[@]}"
do
	vagrant up "$i" && vagrant ssh --command 'sudo salt '"$i"' state.apply'
done
