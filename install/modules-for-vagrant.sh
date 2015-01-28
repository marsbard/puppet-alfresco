#!/bin/bash


mkdir -p modules
for mod in puppetlabs-mysql puppetlabs-stdlib stankevich-python puppetlabs-apache
do
	puppet module install --force $mod --target-dir=modules
done
