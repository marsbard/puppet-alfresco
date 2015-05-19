#!/bin/bash

MODULES="puppetlabs-mysql puppetlabs-stdlib stankevich-python puppetlabs-apache puppetlabs-apt\
  puppetlabs-concat spantree/java8 puppetlabs-vcsrepo"

OS=`head -n1 /etc/issue | cut -f1 -d\ `

if [ "$OS" == "RedHat" -o "$OS" == "CentOS" ]
then
  MODULES="$MODULES stahnma-epel"
fi

if [ ! -x `which puppet` ]
then
	echo Puppet executable not found
	exit 99
fi


hash puppet 2>/dev/null || { echo >&2 "I require puppet but it's not installed.  Aborting."; exit 1; }

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
