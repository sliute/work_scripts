#!/bin/bash
# Luke Carrier wrote this one.

set -euo pipefail
IFS=$'\n\t'

# Platforms to patch up
platforms=(
	avado
	cipd
	dotnative
	squared
)

# Components to replace
dirroot='...'
paths=(
	auth/avadosalesforce
)

# Message
remote='origin'
branch='master'
message='Salesforce integration test prep'

for platform in ${platforms[@]}; do
	pushd $platform
		platformpath="$(pwd -P)"
		git fetch "$remote"
		git reset --hard "${remote}/${branch}"

		for path in ${paths[@]}; do
			pushd "${dirroot}/${path}"
				rm -rf "${platformpath}/${path}"
				git checkout-index -af --prefix "${platformpath}/${path}/"
			popd
		git add "$path"
		done

		git commit -m "$message"
		git push "$remote" "$branch"
	popd
done
