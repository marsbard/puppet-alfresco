#!/bin/bash

MODS="puppetlabs-stdlib puppetlabs-mysql stankevich-python"

ANS_FILE="_answers.sh"

YELLOW='\e[0;33m'
PURPLE='\e[0;35m' # Purple
WHITE='\e[0;37m'
GREEN='\e[0;32m' # Green
BLUE='\e[0;34m'
CYAN='\e[0;36m' # Cyan
RED='\e[0;31m' # Red

RES_COL=30
MOVE_TO_COL="echo -en \\033[${RES_COL}G"
NUMPARAMS="${#params[@]}"


cd "`dirname $0`"

source install/depends.sh
source install/utils.sh
source install/params.sh


read_answers
while [ true ]
do
	bee_banner
	paramloop
	read_entry
done
