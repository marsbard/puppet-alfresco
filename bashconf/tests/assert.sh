
# https://github.com/costa/dev/blob/master/bash/tag_test.sh
function errcho() {
  if [ ! -z "$DEBUG" ]; then echo >&2 "$@"; fi
}
function shout() {
  if [ ! -z "$DEBUG" ]
  then
    errcho "$@"
    "$@"
  fi
}


#######################################################################
# http://tldp.org/LDP/abs/html/debugging.html
assertEquals ()                 #  If condition false,
{                         #  exit from script
                          #  with appropriate error message.
  E_PARAM_ERR=98
  E_ASSERT_FAILED=99


  if [ -z "$4" ]          #  Not enough parameters passed
  then                    #  to assert() function.
    echo assertEquals: not enough params: 1=$1 2=$2 3=$3 4=$4
    return $E_PARAM_ERR   #  No damage done.
  fi

  lineno=$4

  if [ ! "$2" = "$3" ] 
  then
    echo "Assertion failed:  \"$1\"  expected \"$2\", got \"$3\""
    echo "File \"$0\", line $lineno"    # Give name of file and line number.
    exit $E_ASSERT_FAILED
    # else
    #   return
    #   and continue executing the script.
  fi  
} 
