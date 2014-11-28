#!/bin/bash


cd "`dirname $0`"

source install/utils.sh
source install/params.sh
source install/depends.sh

RES_COL=30
MOVE_TO_COL="echo -en \\033[${RES_COL}G"

function paramloop() {
	echo "Installer parameters"
	echo "--------------------"
	echo -en "Idx\tParam"
	$MOVE_TO_COL
	echo Value
	echo

	for i in `seq 1 ${#params}`
	do
		IDX=$(( $i -1 ))
		VAL=`get_answer $IDX`
		echo -en "[$i]\t${params[$IDX]}"
		$MOVE_TO_COL
		echo $VAL
	done
	echo

}
read_answers
EXIT=0
while [ "$EXIT" = "0" ]
do
	bee_banner
	paramloop
	read_entry
done
