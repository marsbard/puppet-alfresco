# helper functions for installer

set -e


ANS_FILE="_answers.sh"

YELLOW='\x1B[0;33m'
PURPLE='\x1B[0;35m' # Purple
WHITE='\x1B[0;37m'
GREEN='\x1B[0;32m' # Green
BLUE='\x1B[0;34m'
CYAN='\x1B[0;36m' # Cyan
RED='\x1B[0;31m' # Red



function paramloop() {
	echo "Installer parameters"
	echo "--------------------"
	echo
	echo -en "Idx\tParam"
	$MOVE_TO_COL
	echo Value
	echo



	for i in `seq 1 ${NUMPARAMS}`
	do
		IDX=$(( $i -1 ))
		#IDX=$i
		VAL=`get_answer $IDX`
		echo -en "[${GREEN}$i${WHITE}]\t${PURPLE}${params[$IDX]}${WHITE}"
		$MOVE_TO_COL
		echo -en $CYAN
		echo $VAL
		echo -en $WHITE
	done
	echo

}



function bee_banner {
	#clear
	echo
	echo -e "${YELLOW}    __    __    __    __    __    __    __    __    __    __"
	echo -e " __/  \\__/  \\__/  \\__/  \\__/  \\__/  \\__/  \\__/  \\__/  \\__/  \\__"
	echo -e "/  \\__ ${BLUE}ORDER OF THE BEE${YELLOW} /  \\__/  \\__/  \\__/  \\__/  \\__/  \\__/  \\"
	echo -e "\\__/  \\__/  \\__/  \\__/  \\ ${BLUE}Alfresco (TM) Honeycomb Edition${YELLOW}   \\__/"
	echo -e "   \\__/  \\__/  \\__/  \\__/  \\__/  \\__/  \\__/  \\__/  \\__/  \\__/ ${WHITE} "
	echo

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


NUMERIC='^[0-9]+$'
function read_entry {
	echo "Please choose an index number to edit, I to install, or Q to quit"
	echo "(if using Vagrant, choose Q not I and run 'vagrant up')"
	read -ep" -> " ENTRY


	if [ "$ENTRY" = "I" -o "$ENTRY" = "i" ]
	then
		write_answers
		write_go_pp
		set +e
		run_install
		# non zero exit might mean that a required field is not filled
		if [ $? = 0 ] 
		then
			exit
		fi
		set -e
		sleep 2
		echo
	elif [ "$ENTRY" = "Q" -o "$ENTRY" = "q" ]
	then
		write_answers
		write_go_pp
		exit
	else
		if [[ $ENTRY =~ $NUMERIC ]]
		then
			if [ $ENTRY -gt $NUMPARAMS ]
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
	touch $ANS_FILE
	for i in `seq 0 $(( $NUMPARAMS -1))`
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

			for i in `seq 0 $(( $NUMPARAMS -1 ))`
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
	IDX=$(( $1 -1 ))
	param="${params[IDX]}"
	value=`get_answer $IDX`
	echo -e "${GREEN}Parameter: ${PURPLE}${param}${WHITE}"
	echo -en $YELLOW
	echo -e "${descr[IDX]}"
	echo -en $BLUE
	echo -n "[$value]"
	echo -en $CYAN
	read -ep": " ANSWER
	echo -en $WHITE
	answers[$IDX]=$ANSWER
}

# given a parameter name find it by index
# and return the value
function get_param {
	param=$1
	for i in `seq 0 $(( $NUMPARAMS -1 )) `
	do
		if [ "${params[i]}" = "$param" ]
		then
			echo `get_answer $i`
			break
		fi
	done
}

function check_required {
	ERRS=0
	echo
	for i in `seq 0 $(( $NUMPARAMS -1 ))`
        do
		if [ "${required[i]}" = "1" -a "`get_answer $i`" = "" ]
		then
			echo -ne $RED
			echo "Error: ${params[i]} is required"
			echo -en $WHITE
			ERRS=1
		fi		
	done
	echo
	return $ERRS
}


function write_go_pp {

	domain_name=`get_param domain_name`
	initial_admin_pass=`get_param initial_admin_pass`
	mail_from_default=`get_param mail_from_default`
	alfresco_base_dir=`get_param alfresco_base_dir`
	tomcat_home=`get_param tomcat_home`
	alfresco_version=`get_param alfresco_version`
	download_path=`get_param download_path`
	db_root_password=`get_param db_root_password`
	db_user=`get_param db_user`
	db_pass=`get_param db_pass`
	db_name=`get_param db_name`
	db_host=`get_param db_host`
	db_port=`get_param db_port`
	mem_xmx=`get_param mem_xmx`
	mem_xxmaxpermsize=`get_param mem_xxmaxpermsize`
  ssl_cert_path=`get_param ssl_cert_path`

	echo -e "${GREEN}Writing puppet file ${BLUE}go.pp${WHITE}"
	cat > go.pp <<EOF
class { 'alfresco':
	domain_name => '${domain_name}',	
	initial_admin_pass => '${initial_admin_pass}',
	mail_from_default => '${mail_from_default}',	
	alfresco_base_dir => '${alfresco_base_dir}',	
	tomcat_home => '${tomcat_home}',	
	alfresco_version => '${alfresco_version}',	
	download_path => '${download_path}',	
	db_root_password => '${db_root_password}',
	db_user => '${db_user}',	
	db_pass => '${db_pass}',	
	db_name => '${db_name}',	
	db_host => '${db_host}',	
	db_port => '${db_port}',	
	mem_xmx => '${mem_xmx}',
	mem_xxmaxpermsize => '${mem_xxmaxpermsize}',
  ssl_cert_path => '${ssl_cert_path}',
}
EOF
	echo -e "${GREEN}Writing puppet file ${BLUE}test.pp${WHITE}"
	cat > test.pp <<EOF
class { 'alfresco::tests':
  delay_before => 10,
	domain_name => '${domain_name}',	
	initial_admin_pass => '${initial_admin_pass}',
	mail_from_default => '${mail_from_default}',	
	alfresco_base_dir => '${alfresco_base_dir}',	
	tomcat_home => '${tomcat_home}',	
	alfresco_version => '${alfresco_version}',	
	download_path => '${download_path}',	
	db_root_password => '${db_root_password}',
	db_user => '${db_user}',	
	db_pass => '${db_pass}',	
	db_name => '${db_name}',	
	db_host => '${db_host}',	
	db_port => '${db_port}',	
	mem_xmx => '${mem_xmx}',
	mem_xxmaxpermsize => '${mem_xxmaxpermsize}',
}
EOF
	sleep 1
}

function run_install {
	check_required
	ERR=$?
	if [ $ERR != 0 ]
	then
		return 1
	fi

	if [ "`which puppet`" = "" ]
	then
		install_puppet
	fi

  ./install/modules-for-vagrant.sh

	puppet apply --modulepath=modules go.pp

  if [ $? != 0 ]; then exit 99; fi

	echo
	echo Completed, please allow some time for alfresco to start
	echo You may tail the logs at ${tomcat_home}/logs/catalina.out
	echo
	echo Note that you can reapply the puppet configuration from this directory with:
	echo "	puppet apply --modulepath=modules go.pp"
	echo
	echo You can also run the tests with:
  echo "  puppet apply --modulepath=modules test.pp"
	echo
}
