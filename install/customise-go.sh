#!/bin/bash
#
# This file exists to support travis build which makes it difficult
# to create this file directly due to strange escaping issues,
# however it may find other automation uses

echo "class { 'alfresco':" > go.pp

while (( "$#" ))
do

  # should be in the format of puppet_fact=value
  OVERRIDE=$1
  FACT=`echo $OVERRIDE | cut -f1 -d=`
  VALUE=`echo $OVERRIDE | cut -f2 -d=`
  
  echo "  ${FACT} => '${VALUE}'," >> go.pp

  shift
done

echo "}" >> go.pp
