#!/bin/bash

cd "`dirname $0`"

if [ $UID != 0 -a $EUID != 0 ]
then
	echo You must be root to run the installer
	exit
fi

# Whatever the contents of $CONF we expect to see at least a
# ${CONF}_params.sh and a ${CONF}_output.sh
#
# We may also optionally find ${CONF}_pre.sh and ${CONF}_install.sh
# and if we find them we run them before and after 

# bootstrap bashconf
git submodule init
git submodule update


export CONF=config/ootb
source bashconf/bashconf.sh
