#!/bin/bash

if [ ! -f puppet-alfresco ]
then
	git clone http://github.com/marsbard/puppet-alfresco.git -b $BRANCH
fi

cd puppet-alfresco
git pull 

git checkout $BRANCH

./install.sh
