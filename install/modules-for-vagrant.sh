#!/bin/bash

MODULES="puppetlabs-mysql puppetlabs-stdlib stankevich-python puppetlabs-apache puppetlabs-apt\
  puppetlabs-concat spantree/java8"

OS=`head -n1 /etc/issue | cut -f1 -d\ `

if [ "$OS" == "RedHat" -o "$OS" == "CentOS" ]
then
  MODULES="$MODULES stahnma-epel"
fi

mkdir -p modules
for mod in $MODULES
do
  TRY=0
  while [ $TRY -lt 3 ]
  do
	  puppet module install --force $mod --target-dir=modules
    if [ $? = 0 ]; then TRY=3; else 
      if [ $TRY -lt 3 ]
      then 
        echo Transient failure, retrying
      else
        echo Failed to install $mod
        exit 99
      fi
    fi
    TRY=$(( TRY++ ))
  done
done
