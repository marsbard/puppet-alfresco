#!/bin/bash

cd "`dirname $0`"

# Whatever the contents of $CONF we expect to see at least a
# ${CONF}_params.sh and a ${CONF}_output.sh
#
# We may also optionally find ${CONF}_pre.sh and ${CONF}_install.sh
# and if we find them we run them before and after 

export CONF=config/ootb
source bashconf/bashconf.sh
