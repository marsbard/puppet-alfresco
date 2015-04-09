
source "`dirname $0`"/../funcs.sh
source "`dirname $0`"/assert.sh

some_value=99
CLAUSE="some_value=12"
onlyif[1]=$CLAUSE
RES=`get_onlyif 1`
assertEquals "$CLAUSE" false $RES $LINENO

CLAUSE="some_value=99"
onlyif[1]=$CLAUSE
RES=`get_onlyif 1`
assertEquals "$CLAUSE" true $RES $LINENO

backuptype=ftp
onlyif[2]="backuptype=scp"
onlyif[3]="backuptype=ftp"

#DEBUG=true

assertEquals "${onlyif[2]}" false `get_onlyif 2` $LINENO
assertEquals "${onlyif[3]}" true `get_onlyif 3` $LINENO


backuptype=scp
assertEquals "${onlyif[3]}" false `get_onlyif 3` $LINENO
assertEquals "${onlyif[2]}" true `get_onlyif 2` $LINENO

