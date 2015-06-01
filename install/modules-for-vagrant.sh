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



mkdir -p modules
for mod in $MODULES
do
  TRY=0
  while [ $TRY -lt 3 ]
  do
		# https://github.com/marsbard/puppet-alfresco/issues/63
		if [ "$mod" = "puppetlabs-concat" ]
		then
			puppet module install --version 1.2.2 --force $mod --target-dir=modules
		else
			puppet module install --force $mod --target-dir=modules
		fi
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
