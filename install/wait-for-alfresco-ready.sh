#!/bin/bash

# # # # # # # # # # 
#
# This script is intended for use in the Travis CI environment, it
# tries to wait for a 2xx response from the alfresco server before
# moving on to the integration test phase. We found however that
# Travis gets stuck quite often and so this script ended up getting
# more and more debugging inside it, as well as attempts to 
# remedy the situation.
#
# Eventually we found a good balance, with TIMEWAIT at 240 seconds
# to allow legitimately long-lived processes a chance to finish
# (e.g. deploying share.war), if the last line of the logfile
# LOGTOTAIL is the same after TIMEWAIT interval, it is assumed
# to be stuck and the VM is rebooted, this causes Travis to re-
# queue the job.
#
# With further diagnosis we found that when the Travis build gets
# stuck, there is info in `dmesg` about the processes that have
# been killed. To optimise the process now we look at the dmesg
# output to see if anything has been killed and if so we reboot.
# This saves 4-8 mins of waiting.
#
# All of which is a long way to say that this script turned into
# a bit of a mess
#
# # # # # # # # # # 

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
    dmesg | egrep -i 'killed process'
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
      #TOMCATPID=`service tomcat status 2>&1 | awk 'NF>1{print $NF}'`
      #echo TOMCATPID=$TOMCATPID
      #sudo kill -9 $TOMCATPID
      #killall -9 mysqld
      #sudo service mysql start
      #killall -9 java
      #sudo /etc/init.d/tomcat start
      #sleep 30
      #sudo reboot
      banner reboot
      sudo reboot
      sleep 30
    fi
    LASTLOGLINE=$NEWLASTLOGLINE
    banner Examining killed processes
    sudo dmesg | egrep -i 'killed process'
    if [ "`dmesg | egrep -i 'killed process'`" != "" ]
    then 
      banner "OOM Killer got me, restarting"
      sudo reboot
      sleep 30
    fi
    echo "---8<---"
    banner "[ `date` ] Sleeping for $TIMEWAIT seconds"
    sleep $TIMEWAIT
  fi
done

