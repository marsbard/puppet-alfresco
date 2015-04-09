
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

