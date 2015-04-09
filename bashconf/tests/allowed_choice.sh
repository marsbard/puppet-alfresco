set -e 

source "`dirname $0`"/../funcs.sh
source "`dirname $0`"/assert.sh

params[0]="keyname"
choices[0]="valz|valium|valiant"

assertEquals "should have an incorrect value" false "`allowed_choice 0 value`" $LINENO
assertEquals "should have an incorrect value" false "`allowed_choice 0 vaulted`" $LINENO
assertEquals "should have an incorrect value" false "`allowed_choice 0 valued`" $LINENO
assertEquals "should have an incorrect value" false "`allowed_choice 0 valzd`" $LINENO

assertEquals "should have a correct value now" true "`allowed_choice 0 valz`" $LINENO
assertEquals "should have a correct value now" true "`allowed_choice 0 valium`" $LINENO
assertEquals "should have a correct value now" true "`allowed_choice 0 valiant`" $LINENO
