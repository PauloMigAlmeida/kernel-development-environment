#!/bin/bash

# meant to be triggered from a kernel tree workdir
alias get_maintainers='./scripts/get_maintainer.pl --separator , --norolestats --remove-duplicates --non'
alias checkpatch='./scripts/checkpatch.pl --strict'
function sendpatch() {
	PATCH_FILE=$1
	mutt -H $1 -c $(git config user.email) $(get_maintainers $1) 
}
