#!/bin/bash

MODULES="puppetlabs-mysql puppetlabs-stdlib stankevich-python puppetlabs-apache puppetlabs-apt\
  puppetlabs-concat"

OS=`head -n1 /etc/issue | cut -f1 -d\ `

if [ "$OS" == "RedHat" -o "$OS" == "CentOS" ]
then
  MODULES="$MODULES stahnma-epel"
fi

mkdir -p modules
for mod in $MODULES
do
	puppet module install --force $mod --target-dir=modules
done
