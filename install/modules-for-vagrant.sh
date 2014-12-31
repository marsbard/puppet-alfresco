#!/bin/bash


mkdir -p modules
for mod in puppetlabs-mysql puppetlabs-stdlib
do
	puppet module install --force $mod --target-dir=modules
done
