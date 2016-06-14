#!/bin/bash

git clone http://github.com/marsbard/puppet-alfresco.git

cd puppet-alfresco

if [ "$BRANCH" = "" ]
then
	echo please run this like './docker-run.sh <branch name>'
	exit
fi

git checkout $BRANCH
