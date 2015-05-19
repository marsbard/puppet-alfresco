
set -e 

source "`dirname $0`"/../funcs.sh
source "`dirname $0`"/assert.sh


params[0]=selector
answers[0]=blah

params[1]=foo
onlyif[1]="selector=ditz"

params[2]=bar
answers[2]=bad

params[3]=baz
answers[3]=bam

assertEquals "num params=4" 4 ${#params[@]} $LINENO

assertEquals "shown params=3" 3 "`count_effective_params`" $LINENO

assertEquals "get_effective_idx 2 returns '3'" 3 "`get_effective_idx 2`" $LINENO

assertEquals "get_effective_answer 2 gives value 'bam'" bam "`get_effective_answer 2`" $LINENO

