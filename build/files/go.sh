#!/bin/bash

if [ "$BRANCH" = "" ]
then
	echo please run this like './docker-run.sh <branch name>'
	exit
fi

if [ ! -f puppet-alfresco ]
then
	git clone http://github.com/marsbard/puppet-alfresco.git -b $BRANCH
fi

cd puppet-alfresco
git pull 

git checkout $BRANCH

./install.sh
