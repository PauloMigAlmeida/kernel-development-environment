#!/bin/bash

load_reproducible_kernel_env(){
	KBF="KBUILD_BUILD_TIMESTAMP=1980-01-01 KBUILD_BUILD_USER=user KBUILD_BUILD_HOST=host KBUILD_BUILD_VERSION=1"	
	if [[ -n "$1" && -n "$2" ]]; then
		KBF="${KBF} ARCH=$1 CROSS_COMPILE=$2"
	fi
	export KBF

	if [[ -n "$3" ]]; then
		echo "output folder $3"
		OUT=$3
	else
		echo "no output folder choosen, using gcc"
		OUT=gcc
	fi
	
	rm -rf gcc
	export OUT

	if [[ -n "$4" ]]; then
	    	echo "running allmodconfig"
		make $KBF O=$OUT allmodconfig
	else
		echo "running defconfig"
		make $KBF O=$OUT defconfig
	fi
	make $KBF O=$OUT allmodconfig
	./scripts/config --file $OUT/.config \
	        -d GCOV_KERNEL -d KCOV -d GCC_PLUGINS -d IKHEADERS -d KASAN -d UBSAN \
		-d DEBUG_INFO_NONE -e DEBUG_INFO_DWARF_TOOLCHAIN_DEFAULT
	make $KBF O=$OUT olddefconfig
}

alias grep_fake_1_array_in_drivers="git grep -P -e '^[\w\s\t]*?[\s\t]*\w*?\[1\]\;' -n  drivers/"

copy_binaries(){
	SRC_FOLDER=$1
	DST_FOLDER=$2
	
	echo "cleaning $DST_FOLDER directory"
	rm -rf $DST_FOLDER/*
	
	echo "copying object files/kernel mods from $SRC_FOLDER to $DST_FOLDER"
	for f in $(find $SRC_FOLDER -type f -iname *.ko -o -iname *.o)
	do
		OUTPUT_PATH="${DST_FOLDER}$(dirname $f)"
		mkdir -p $OUTPUT_PATH
		cp $f $OUTPUT_PATH 
	done
}

binary_diff_folder(){
	DIFF_U_NUM=${1:-3}
	DIFF_ARGS="--disassemble --demangle --reloc --no-show-raw-insn --section=.text -M intel"
	for BEFORE in $(find $OUT/before -type f -iname *.ko -o -iname *.o); do
		echo $BEFORE
		AFTER=$(echo $BEFORE | sed 's/\/before\//\/after\//')
	        diff -u$DIFF_U_NUM <(objdump $DIFF_ARGS $BEFORE | sed "0,/^Disassembly/d") \
		        <(objdump $DIFF_ARGS $AFTER  | sed "0,/^Disassembly/d")
	done
}

binary_diff_ui(){	
	BEFORE=$1
	AFTER=$(echo $BEFORE | sed 's/\/before\//\/after\//')

	OPT_LINE_NUMBERS=${2};
	DIFF_ARGS="--disassemble --demangle --reloc --no-show-raw-insn --section=.text -M intel"

	if [ ! -z "${OPT_LINE_NUMBERS}" ]; then
		DIFF_ARGS="${DIFF_ARGS} --line-numbers"
	fi
	meld <(objdump $DIFF_ARGS $BEFORE | sed "0,/^Disassembly/d") \
		<(objdump $DIFF_ARGS $AFTER | sed "0,/^Disassembly/d")
}

