
# Return true if the supplied answer is among the allowed choices
function allowed_choice {

  IDX=$1
  ANSWER=$2
  CHOICES="${choices[IDX]}"

  if [ "$CHOICES" = "" ]
  then
    # nothing to check
    return
  fi

  # http://stackoverflow.com/a/10586169
  IFS="|" read -a ALLOWED <<< "$CHOICES"

  for i in `seq 0 $(( ${#ALLOWED[@]} + 1 ))`
  do
    CHOICE=${ALLOWED[$i]}
    [ ! -z $DEBUG ] && echo CHOICE=$CHOICE ANSWER=$ANSWER
    if [ "$ANSWER" = "$CHOICE" ]
    then
      echo "true"
      return
    fi
  done
  echo "false"
  return

}

# Return the number of effective parameters taking into 
# account the 'onlyif' setting
function count_effective_params {
  COUNT=0
	for i in `seq 0 $(( ${#params[@]} -1 )) `
	do
    OI=`get_onlyif $i`
    if [ $OI = true ]
    then
      COUNT=$(( $COUNT + 1))
    fi
  done
  echo $COUNT
}

# Given an index number, return the actual
# index number taking into account the onlyif setting
function get_effective_idx {
  IDX=$1
  EFFIDX=0
	for i in `seq 0 $(( ${#params[@]} -1 )) `
	do
    OI=`get_onlyif $i`
    if [ $OI = true ]
    then
      if [ $((EFFIDX++)) -eq $IDX ]
      then
        echo $i
        return
      fi
    fi
  done
}

# Given an index number, return the answer
# taking into account the onlyif setting
function get_effective_answer {
  IDX=$1
  EFFIDX=`get_effective_idx $IDX`
  echo `get_answer $EFFIDX`
}

function get_answer {
	IDX=$1
	if [ "${answers[$IDX]}" != "" ]
	then 
		echo ${answers[$IDX]}
		return
	fi
	echo ${default[$IDX]}
}


# given a parameter name find it by index
# and return the value
function get_param {
	param=$1
	for i in `seq 0 $(( ${#params[@]} -1 )) `
	do
		if [ "${params[i]}" = "$param" ]
		then
			echo `get_answer $i`
			break
		fi
	done
}

# echo 'true' or 'false' depending on whether the onlyif clause is satisfied
function get_onlyif {
	IDX=$1
	ONLYIF=${onlyif[$IDX]}
  LEFT=`echo $ONLYIF | cut -f1 -d=`
  RIGHT=`echo $ONLYIF | cut -f2 -d=`

  #eval "VAL=\$$LEFT"
  VAL=`get_param $LEFT`

  if [ ! -z "$DEBUG" ]
  then
    >&2 echo ------
    >&2 echo IDX=$IDX
    >&2 echo ONLYIF=$ONLYIF
    >&2 echo LEFT=$LEFT
    >&2 echo RIGHT=$RIGHT
    >&2 echo VAL=$VAL
  fi

  if [ "$VAL" = "$RIGHT" ]
  then 
    RES=true
  else 
    RES=false
  fi

  if [ ! -z "$DEBUG" ]; then >&2 echo RES=$RES; fi
  echo $RES
}

