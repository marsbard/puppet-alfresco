#!/bin/bash

URL=$1

READY=false
COUNT=0
while [ $READY == false ]
do 
  COUNT=$(( $COUNT + 1)) 
  if [ $COUNT -ge 10 ] 
  then
    exit 99
  fi
  RES=`wget --no-check-certificate --server-response $URL 2>&1 | awk '/^  HTTP/{print $2}' | tail -n 1`
  echo "$COUNT - $RES" 
  if [ "$RES" == "" ]; then RES=999; fi
  if [ "$RES" -le 299 ]
  then 
    READY=true
  else 
    echo "Response was $RES, waiting" 
    sleep 30
  fi
done

