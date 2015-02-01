#!/bin/bash

MODULES="puppetlabs-mysql puppetlabs-stdlib stankevich-python puppetlabs-apache puppetlabs-apt\
  puppetlabs-concat"

mkdir -p modules
for mod in $MODULES
do
	puppet module install --force $mod --target-dir=modules
done
