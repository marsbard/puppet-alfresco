set -e 

source "`dirname $0`"/../funcs.sh
source "`dirname $0`"/assert.sh

params[0]="keyname"
choices[0]="valz|valium|valiant|variant"

assertEquals "should have an incorrect value" false "`allowed_choice 0 value`" $LINENO
assertEquals "should have an incorrect vaulted" false "`allowed_choice 0 vaulted`" $LINENO
assertEquals "should have an incorrect valued" false "`allowed_choice 0 valued`" $LINENO
assertEquals "should have an incorrect valzd" false "`allowed_choice 0 valzd`" $LINENO

assertEquals "should have a correct valz now" true "`allowed_choice 0 valz`" $LINENO
assertEquals "should have a correct valium now" true "`allowed_choice 0 valium`" $LINENO
assertEquals "should have a correct valiant now" true "`allowed_choice 0 valiant`" $LINENO
assertEquals "should have a correct variant now" true "`allowed_choice 0 variant`" $LINENO
