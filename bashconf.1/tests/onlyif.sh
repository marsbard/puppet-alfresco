
source "`dirname $0`"/../funcs.sh
source "`dirname $0`"/assert.sh

some_value=99

params[0]="backuptype"
answers[0]="ftp"

params[1]="some_value"
answers[1]=99
onlyif[1]="some_value=12"

params[2]="value2"
answers[2]=88
onlyif[2]="backuptype=scp"


params[3]="blah"
answers[3]=77
onlyif[3]="backuptype=ftp"

CLAUSE="some_value=12"
RES=`get_onlyif 1`
assertEquals "$CLAUSE" false $RES $LINENO


onlyif[1]="some_value=99"
RES=`get_onlyif 1`
assertEquals "${onlyif[1]}" true $RES $LINENO


assertEquals "${onlyif[2]}" false `get_onlyif 2` $LINENO
assertEquals "${onlyif[3]}" true `get_onlyif 3` $LINENO

answers[0]="scp"

assertEquals "${onlyif[3]}" false `get_onlyif 3` $LINENO
assertEquals "${onlyif[2]}" true `get_onlyif 2` $LINENO

