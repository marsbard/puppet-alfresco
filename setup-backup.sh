#!/bin/bash

cd "`dirname $0`"

if [ "$EUID" != "0" ]
then
	echo This script must be run as root
	exit
fi

# hmm this is going to a bit convoluted


CONF=config/backup bashconf/bashconf.sh
