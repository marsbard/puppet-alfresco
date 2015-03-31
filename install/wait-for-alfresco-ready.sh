#!/bin/bash

URL=$1
TIMEWAIT=$2
MAXWAITS=$3
LOGTOTAIL=$4

sudo apt-get -y install sysstat

banner () {
  echo ==============
  echo $*
  echo ----
}

LASTLOGLINE=""

READY=false
COUNT=0
while [ $READY == false ]
do 
  COUNT=$(( $COUNT + 1)) 
  if [ $COUNT -gt $MAXWAITS ] 
  then
    echo Exceeded $MAXWAITS loops, exiting
    echo "---8<---"
    tail -n 30 $LOGTOTAIL
    echo "---8<---"
    exit 99
  fi
  RES=`wget --no-check-certificate --server-response $URL 2>&1 | awk '/^  HTTP/{print $2}' | tail -n 1`
  echo "$COUNT - $RES" 
  if [ "$RES" == "" ]; then RES=999; fi
  if [ "$RES" -le 299 ]
  then 
    READY=true
  else 
    echo "Response was $RES, waiting $TIMEWAIT secs, showing current top status and last alfresco log tail" 
    echo "---8<---"
    banner "ps ax | grep alf"
    ps ax | grep alf
    banner "top | head"
    `dirname "$0"`/tophead.sh
    #iostat No iostat inside openvz container
    banner mpstat
    mpstat
    banner beancounters
    sudo cat /proc/user_beancounters
    banner Tail of $LOGTOTAIL
    tail $LOGTOTAIL
    NEWLASTLOGLINE=`tail -n1 $LOGTOTAIL`
    if [ "$NEWLASTLOGLINE" == "$LASTLOGLINE" ]
    then
      banner Job looks stuck, restarting tomcat
      sudo rm -rf $LOGTOTAIL
      sudo killall -9 tomcat7
      sudo /etc/init.d/tomcat7 restart
    fi
    LASTLOGLINE=$NEWLASTLOGLINE
    banner Tail of syslog
    sudo tail /var/log/syslog
    echo "---8<---"
    sleep $TIMEWAIT
  fi
done

