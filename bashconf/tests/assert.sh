#######################################################################
# http://tldp.org/LDP/abs/html/debugging.html
assertEquals ()                 #  If condition false,
{                         #  exit from script
                          #  with appropriate error message.
  E_PARAM_ERR=98
  E_ASSERT_FAILED=99


  if [ -z "$4" ]          #  Not enough parameters passed
  then                    #  to assert() function.
    return $E_PARAM_ERR   #  No damage done.
  fi

  lineno=$4

  if [ ! $2 = $3 ] 
  then
    echo "Assertion failed:  \"$1\"  expected \"$2\", got \"$3\""
    echo "File \"$0\", line $lineno"    # Give name of file and line number.
    exit $E_ASSERT_FAILED
    # else
    #   return
    #   and continue executing the script.
  fi  
} 
