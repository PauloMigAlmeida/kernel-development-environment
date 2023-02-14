#!/bin/bash

function secure_remove() {
	ARGS=$1
	
	UNAME_OUT=$(uname)
	if [ $UNAME_OUT == 'Darwin' ]; then
		STAT_ARGS="-f %z"
	elif [ $UNAME_OUT == 'Linux' ]; then
		STAT_ARGS="-c %s"
	else
		echo "this seems to be running on an unknown OS. Aborting"
		return 11
	fi

	if [[ ! -f $ARGS && ! -d $ARGS ]]; then
		echo "$ARGS is neither a file or directory.. aborting"
		return 1
	fi	       
	
	FILES=$(find $ARGS -type f;)
	for f in $FILES
	do
		echo -n "file: $f ... "
		f_size=$(stat $STAT_ARGS $f)
		echo -n "zeroing-out ..."
		dd if=/dev/zero of=$f bs=1 count=$f_size status='none'
		echo -n "randomizing-out ..."
		dd if=/dev/random of=$f bs=1 count=$f_size status='none'
		echo -n "zeroing-out ... "
		dd if=/dev/zero of=$f bs=1 count=$f_size status='none'
		echo "deleting it"
		rm -f $f
	done

	rm -rf $ARGS
}

alias secrm='secure_remove'
