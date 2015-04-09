
# echo 'true' or 'false' depending on whether the onlyif clause is satisfied
function get_onlyif {
	IDX=$1
	ONLYIF=${onlyif[$IDX]}
  LEFT=`echo $ONLYIF | cut -f1 -d=`
  RIGHT=`echo $ONLYIF | cut -f2 -d=`

  eval "VAL=\$$LEFT"

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

