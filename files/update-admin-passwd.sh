#!/bin/bash
#
# update-admin-passwd.sh <password> <mysql_db> <mysql_user> <mysql_pass> 
#
set -e

PASSWD=$1
MYSQL_DB=$2
MYSQL_USER=$3
MYSQL_PASS=$4

if [ "$PASSWD" = "" -o "$MYSQL_DB" = "" -o "$MYSQL_USER" = "" ]
then
	echo "Usage: update-admin-passwd.sh <password> <mysql_db> <mysql_user> [<mysql_pass>]"
	exit
fi

if [ "`which iconv`" = "" -o "`which openssl`" = "" ]
then 
	echo iconv and openssl must both be installed
	exit
fi


SQL="SELECT anp1.node_id, anp1.qname_id, anp1.string_value FROM alf_node_properties anp1 INNER JOIN alf_qname aq1 ON aq1.id = anp1.qname_id INNER JOIN alf_node_properties anp2 ON anp2.node_id = anp1.node_id INNER JOIN alf_qname aq2 ON aq2.id = anp2.qname_id WHERE aq1.local_name    = 'password'  AND aq2.local_name  = 'username' AND anp2.string_value = 'admin';"

result=` echo $SQL | mysql -u${MYSQL_USER} -p${MYSQL_PASS} ${MYSQL_DB} | tail -n1 | xargs`

node_id=`echo $result | cut -f1 -d\ `
qname_id=`echo $result | cut -f2 -d\ `
passwd_hash=`echo $result | cut -f3 -d\ `

#echo node_id=${node_id}
#echo qname_id=${qname_id}
echo current passwd_hash=${passwd_hash}


PASSWD_HASH=`iconv -f ASCII -t UTF-16LE <(printf "${PASSWD}") | openssl dgst -md4 | cut -f2 -d\ `


echo new passwd_hash=${PASSWD_HASH}

SQL="UPDATE alf_node_properties SET string_value='${PASSWD_HASH}' WHERE node_id=${node_id} and qname_id=${qname_id};"
 echo $SQL | mysql -u${MYSQL_USER} -p${MYSQL_PASS} ${MYSQL_DB}

echo Password has been changed

SQL="SELECT anp1.node_id, anp1.qname_id, anp1.string_value FROM alf_node_properties anp1 INNER JOIN alf_qname aq1 ON aq1.id = anp1.qname_id INNER JOIN alf_node_properties anp2 ON anp2.node_id = anp1.node_id INNER JOIN alf_qname aq2 ON aq2.id = anp2.qname_id WHERE aq1.local_name    = 'password'  AND aq2.local_name  = 'username' AND anp2.string_value = 'admin';"

result=` echo $SQL | mysql -u${MYSQL_USER} -p${MYSQL_PASS} ${MYSQL_DB} | tail -n1 | xargs`
passwd_hash=`echo $result | cut -f3 -d\ `

echo Updated password hash is confirmed as ${passwd_hash}


