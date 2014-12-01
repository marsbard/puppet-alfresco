#!/bin/bash


cd "`dirname $0`"

source install/depends.sh
source install/utils.sh
source install/params.sh

RES_COL=30
MOVE_TO_COL="echo -en \\033[${RES_COL}G"


NUMPARAMS="${#params[@]}"

function paramloop() {
	echo "Installer parameters"
	echo "--------------------"
	echo
#	echo
#	echo Number of parameters: "${NUMPARAMS}"
#	echo
#	echo
	echo -en "Idx\tParam"
	$MOVE_TO_COL
	echo Value
	echo



	for i in `seq 1 ${NUMPARAMS}`
	do
		IDX=$(( $i -1 ))
		#IDX=$i
		VAL=`get_answer $IDX`
		echo -en "[${GREEN}$i${WHITE}]\t${PURPLE}${params[$IDX]}${WHITE}"
		$MOVE_TO_COL
		echo -en $CYAN
		echo $VAL
		echo -en $WHITE
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
