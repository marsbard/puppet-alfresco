#!/bin/bash

#set -e

cd "`dirname $0`"

ME="`basename $0`"

for FILE in `ls`
do
  if [ -x $FILE -a $FILE != $ME ]
  then
    echo Running test: $FILE
    ./$FILE
    echo ---
  fi
done
