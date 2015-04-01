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

  # short circuit the check if we know the OOM killer has been active
  if [ "`dmesg | egrep -i 'killed process'`" != "" ]
  then 
    banner "OOM Killer got me, restarting"
    sudo reboot
    sleep 30
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
      banner Job looks stuck, restarting 
      #TOMCATPID=`service tomcat7 status 2>&1 | awk 'NF>1{print $NF}'`
      #echo TOMCATPID=$TOMCATPID
      #sudo kill -9 $TOMCATPID
      #killall -9 mysqld
      #sudo service mysql start
      #killall -9 java
      #sudo /etc/init.d/tomcat7 start
      #sleep 30
      #sudo reboot
      banner telinit 1
      sudo telinit 1
      banner Wait 30 secs for services to end
      sleep 30
      banner telinit 3
      sudo telinit 3
    fi
    LASTLOGLINE=$NEWLASTLOGLINE
    banner Examining killed processes
    sudo dmesg | egrep -i 'killed process'
    echo "---8<---"
    banner "[ `date` ] Sleeping for $TIMEWAIT seconds"
    sleep $TIMEWAIT
  fi
done

