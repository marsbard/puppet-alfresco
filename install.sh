#!/bin/bash


cd "`dirname $0`"

source install/depends.sh
source install/utils.sh
source install/params.sh

RES_COL=30
MOVE_TO_COL="echo -en \\033[${RES_COL}G"
NUMPARAMS="${#params[@]}"
RESET="\x1B[0m"

read_answers
while [ true ]
do
	bee_banner
	paramloop
	read_entry
done

echo -e $RESET
