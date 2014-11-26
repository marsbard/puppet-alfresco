#!/bin/bash
#
# show-admin-passwd.sh <mysql_db> <mysql_user> <mysql_pass>
#
set -e

MYSQL_DB=$1
MYSQL_USER=$2
MYSQL_PASS=$3

if [ "$MYSQL_DB" = "" -o "$MYSQL_USER" = "" ]
then
        echo "Usage: show-admin-passwd.sh <mysql_db> <mysql_user> [<mysql_pass>]"
        exit
fi


SQL="SELECT anp1.node_id, anp1.qname_id, anp1.string_value FROM alf_node_properties anp1 INNER JOIN alf_qname aq1 ON aq1.id = anp1.qname_id INNER JOIN alf_node_properties anp2 ON anp2.node_id = anp1.node_id INNER JOIN alf_qname aq2 ON aq2.id = anp2.qname_id WHERE aq1.local_name    = 'password'  AND aq2.local_name  = 'username' AND anp2.string_value = 'admin';"

result=` echo $SQL | mysql -u${MYSQL_USER} -p${MYSQL_PASS} ${MYSQL_DB} | tail -n1 | xargs`

node_id=`echo $result | cut -f1 -d\ `
qname_id=`echo $result | cut -f2 -d\ `
passwd_hash=`echo $result | cut -f3 -d\ `

echo ${passwd_hash}

