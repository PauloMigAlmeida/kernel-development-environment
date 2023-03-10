#!/bin/bash

# Apple removed the rm -P flag which writes 0x00, 0xFF and 0x00 before deleting the file
# on new versions of MacOS. I really liked that =/ Anyway, I simply didn't like the other
# alternatives out there so I decided to put together a script that does something
# similar. It works on both Linux and MacOs.
#
# Usage:
#	secrm /var/log/bootstrap.log 	(for a single file)
#	secrm /var/log			(for a directory)

function secure_remove() {
	ARGS=$1
	
	if [[ ! -f "$ARGS" && ! -d "$ARGS" ]]; then
		echo "$ARGS is neither a file or directory.. aborting"
		return 1
	fi
	
	UNAME_OUT=$(uname)
	if [[ $UNAME_OUT == 'Darwin' ]]; then
		STAT_ARGS="-f %z"
	elif [[ $UNAME_OUT == 'Linux' ]]; then
		STAT_ARGS="-c %s"
	else
		echo "this seems to be running on an unknown OS. Aborting"
		return 1
	fi	       
	
	find "$ARGS" -type f -print0 | while IFS= read -r -d '' f; 
	do
		echo -n "file: $f ... "
		f_size=$(stat $STAT_ARGS "$f")
		echo -n "zeroing-out ..."
		dd if=/dev/zero of="$f" bs=1 count=$f_size status='none'
		echo -n "randomizing-out ..."
		dd if=/dev/random of="$f" bs=1 count=$f_size status='none'
		echo -n "zeroing-out ... "
		dd if=/dev/zero of="$f" bs=1 count=$f_size status='none'
		echo "deleting it"
		rm -f "$f"
	done

	rm -rf "$ARGS"
}

alias secrm='secure_remove'
