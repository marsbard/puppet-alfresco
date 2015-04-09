# Bash configurator

set -e

# ANSI colours
YELLOW='\x1B[0;33m'
PURPLE='\x1B[0;35m' # Purple
WHITE='\x1B[0;37m'
GREEN='\x1B[0;32m' # Green
BLUE='\x1B[0;34m'
CYAN='\x1B[0;36m' # Cyan
RED='\x1B[0;31m' # Red

# column to start printing the values in
RES_COL=35

# ANSI macro for moving cursor
MOVE_TO_COL="echo -en \\033[${RES_COL}G"

# ANSI Reset code
RESET="\x1B[0m"

#######
# Envars for "pre" stage
#######
# Override these envars in ${CONF}_pre.sh if you like
BANNER="${YELLOW}======================================================\n\
${WHITE}Bash Configurator https://github.com/marsbard/bashconf\n\
${YELLOW}======================================================${RESET}"

INSTALL_LETTER="I"
QUIT_LETTER="Q"
PROMPT="${WHITE}Please choose an index number to edit, I to install, or Q to quit${RESET}"
#######



# We expect $CONF to be set here and for $CONF_params.sh
# and $CONF_output.sh to exist
if [ ! -f "${CONF}_params.sh" ]
then
  echo "${RED}Parameters file ${CONF}_params.sh does not exist${RESET}"
  exit 100
else
  source "${CONF}_params.sh"
fi

if [ ! -f "${CONF}_output.sh" ]
then
  echo -e "${RED}Output script ${CONF}_output.sh does not exist.\nWhen called it should write the output file.${RESET}"
  exit 101
fi

# if we have a ${CONF}_pre.sh file, read it, here we can override
# $INSTALL_LETTER, $PROMPT, $QUIT_LETTER, $BANNER
if [ -f "${CONF}_pre.sh" ]
then
  echo loading ${CONF}_pre.sh
  source "${CONF}_pre.sh"
fi



# If we have defined an install letter, warn if we have not provided install script
if [ "${INSTALL_LETTER}" != "" ]
then
  if [ ! -f "${CONF}_install.sh" ]
  then
    echo -e "${RED}WARN${YELLOW} Install letter is defined but ${BLUE}${CONF}_install.sh${YELLOW} not found.\n     You can override \$INSTALL_LETTER in ${BLUE}${CONF}_pre.sh${YELLOW}.${RESET}"
    sleep 2
  fi
fi

# We'll store the answers here
ANS_FILE="${CONF}_answers.sh"


source bashconf/funcs.sh

function paramloop() {
	echo -en "Idx\tParam"
	$MOVE_TO_COL
	echo Value
	echo

  NUM_SHOWN_PARAMS=0

  DISPLAY_IDX=1
	for i in `seq 1 ${#params[@]}`
	do
		PARAM_IDX=$(( $i -1 ))


    ONLYIF=`get_onlyif $PARAM_IDX`
    if [ "$ONLYIF" != "false" ]
    then
      NUM_SHOWN_PARAMS=$(( $NUM_SHOWN_PARAMS + 1 ))
		  VAL=`get_answer $PARAM_IDX`
		  echo -en "[${GREEN}${DISPLAY_IDX}${WHITE}]\t${PURPLE}${params[$PARAM_IDX]}${WHITE}"
		  $MOVE_TO_COL
		  echo -en $CYAN
		  echo $VAL
		  echo -en $WHITE
      DISPLAY_IDX=$(( $DISPLAY_IDX + 1 ))
    fi

	done
	echo

}


function banner {
  echo
  echo -e "${BANNER}${RESET}"
  echo
}




NUMERIC='^[0-9]+$'
function read_entry {
  echo -e $PROMPT
	read -ep" -> " ENTRY


  if [ "${ENTRY,,}" = "${INSTALL_LETTER,,}" ]
	then

    set +e 
    check_required 
    NUMERRS=$?
    set -e
		# non zero exit might mean that a required field is not filled
		if [ "$NUMERRS" != "0" ] 
    then
      sleep 3
      return
		fi

    echo Installing...
		write_answers
    source "${CONF}_output.sh"
    if [ -f "${CONF}_install.sh" ]
    then
      source "${CONF}_install.sh" 
    else
      echo -e "${RED}Error: ${CONF}_install.sh does not exist${YELLOW} but we are installing now${RESET}"
      exit 99
    fi
		sleep 2
		echo
	elif [ "${ENTRY,,}" = "${QUIT_LETTER,,}" ]
	then
		write_answers
    source "${CONF}_output.sh"
		exit
	else
		if [[ $ENTRY =~ $NUMERIC ]]
		then
			if [ $ENTRY -gt $NUM_SHOWN_PARAMS ]
			then	
				echo
				echo -e ${RED}Error: that number is too high${WHITE} 
				echo 
				sleep 2
			else	
				edit_param $ENTRY
			fi
		else
			echo
			echo -e ${RED}Error: that entry was not numeric or one of the allowed characters${WHITE}
			echo
			sleep 2
		fi
	fi

}

function write_answers {
	echo -e ${GREEN}Writing answer file ${BLUE}$ANS_FILE${WHITE}
	#if [ -f $ANS_FILE ]; then mv $ANS_FILE $ANS_FILE.1; fi
  echo > $ANS_FILE
	for i in `seq 0 $(( ${#params[@]} -1))`
	do
		if [ "${answers[$i]}" != "" ]
		then
			echo "${params[$i]}=${answers[$i]}" >> $ANS_FILE
		fi
	done
}

function read_answers {
	if [ -f $ANS_FILE ]
	then
		readarray LINES < $ANS_FILE
		for lineIdx in `seq 0 $(( ${#LINES[@]} ))`
		do
			line="${LINES[$lineIdx]}"
			param=`echo $line | cut -f1 -d= `
			value=`echo $line | cut -f2 -d= `

			for i in `seq 0 $(( ${#params[@]} -1 ))`
			do
				if [ "${params[i]}" = "$param" ]
				then
					answers[i]=$value
					break
				fi
			done
		done 
	fi
}

function edit_param {
	IDX=`get_effective_idx $(( $1 -1 ))`
	param="${params[IDX]}"
	value=`get_answer $IDX`
	echo -e "${GREEN}Parameter: ${PURPLE}${param}${WHITE}"
  if [ "${choices[IDX]}" != "" ] 
  then
    echo -e "${GREEN}Allowed values: ${PURPLE}${choices[IDX]}"
  fi
	echo -en $YELLOW
	echo -e "${descr[IDX]}"
	echo -en $BLUE
	echo -n "[$value]"
	echo -en $CYAN
	read -ep": " ANSWER
	echo -en $WHITE
  if [ "${choices[IDX]}" != "" ] 
  then
    if [ "`allowed_choice $IDX $ANSWER`" = "true" ]
    then
	    answers[$IDX]=$ANSWER
    else
      echo -e "${RED}Error: ${YELLOW}'$ANSWER'${RED} is not a member of ${PURPLE}${choices[IDX]}${RESET}"
      sleep 2
    fi
  else
	    answers[$IDX]=$ANSWER
  fi
}

function check_required {
	ERRS=0
	echo
	for i in `seq 0 $(( ${#params[@]} -1 ))`
  do
		if [ "${required[i]}" = "1" -a "`get_answer $i`" = "" ]
		then
      if [ "`get_onlyif $i`" = "true" ]
      then
			  echo -ne $RED
			  echo "Error: ${params[i]} is required"
			  echo -en $WHITE
        ERRS=$(( $ERRS + 1 ))
      fi
		fi		
	done
	echo $ERRS errors
	return $ERRS
}



read_answers
while [ true ]
do
	banner
	paramloop
	read_entry
done

echo -e $RESET
