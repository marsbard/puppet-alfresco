# helper functions for installer

set -e


ANS_FILE="install/answers.sh"

function bee_banner {
	#clear
	echo
	echo "    __    __    __    __    __    __    __    __    __    __"
	echo " __/  \\__/  \\__/  \\__/  \\__/  \\__/  \\__/  \\__/  \\__/  \\__/  \\__"
	echo "/  \\__ ORDER OF THE BEE /  \\__/  \\__/  \\__/  \\__/  \\__/  \\__/  \\"
	echo "\\__/  \\__/  \\__/  \\__/  \\ Alfresco (TM) Honeycomb Edition   \\__/"
	echo "   \\__/  \\__/  \\__/  \\__/  \\__/  \\__/  \\__/  \\__/  \\__/  \\__/  "
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


function read_entry {
	echo "Please choose an index number to edit, I to install, or Q to quit"
	read -ep" -> " ENTRY

	if [ "$ENTRY" = "I" -o "$ENTRY" = "i" ]
	then
		write_answers
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
		exit
	else
		edit_param $ENTRY
	fi

}

function write_answers {
	echo Writing answer file $ANS_FILE
	if [ -f $ANS_FILE ]; then mv $ANS_FILE $ANS_FILE.1; fi
	touch $ANS_FILE
	for i in `seq 0 $(( ${#params} -1))`
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
		for lineIdx in `seq 0 $(( ${#LINES} ))`
		do
			line="${LINES[$lineIdx]}"
			param=`echo $line | cut -f1 -d= `
			value=`echo $line | cut -f2 -d= `

			for i in `seq 0 $(( ${#params} -1 ))`
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
	descr="${descr[IDX]}"
	value=`get_answer $IDX`
	echo "Parameter: $param"
	echo $descr
	echo -n "[$value]"
	read -ep": " ANSWER
	answers[$IDX]=$ANSWER
}

# given a parameter name find it by index
# and return the value
function get_param {
	param=$1
	for i in `seq 0 $(( ${#params} -1 ))`
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
	for i in `seq 0 $(( ${#params} -1 ))`
        do
		if [ "${required[i]}" = "1" -a "`get_answer $i`" = "" ]
		then
			echo "Error: ${params[i]} is required"
			ERRS=1
		fi		
	done
	echo
	return $ERRS
}


function run_install {
	check_required
	ERR=$?
	if [ $ERR != 0 ]
	then
		return 1
	fi

	domain_name=`get_param domain_name`
	mail_from_default=`get_param mail_from_default`
	alfresco_base_dir=`get_param alfresco_base_dir`
	tomcat_home=`get_param tomcat_home`
	alfresco_version=`get_param alfresco_version`
	download_path=`get_param download_path`
	db_user=`get_param db_user`
	db_pass=`get_param db_pass`
	db_name=`get_param db_name`
	db_host=`get_param db_host`
	db_port=`get_param db_port`

	echo "Writing puppet file go.pp"
	cat > go.pp <<EOF
class { 'alfresco':
	domain_name => '${domain_name}',	
	mail_from_default => '${mail_from_default}',	
	alfresco_base_dir => '${alfresco_base_dir}',	
	tomcat_home => '${tomcat_home}',	
	alfresco_version => '${alfresco_version}',	
	download_path => '${download_path}',	
	db_user => '${db_user}',	
	db_pass => '${db_pass}',	
	db_name => '${db_name}',	
	db_host => '${db_host}',	
	db_port => '${db_port}',	
}
EOF
	sleep 1

	if [ "`which puppet`" = "" ]
	then
		install_puppet
	fi
	MODS="puppetlabs-stdlib puppetlabs-mysql"
	for MOD in $MODS
	do
		puppet module install --force $MOD --target-dir modules
	done
	puppet apply --modulepath=modules go.pp

	# HMM TODO - this doesn't get run for some reason when puppet finishes
	echo
	echo Completed, please allow some time for alfresco to start
	echo You may tail the logs at ${tomcat_home}/logs/catalina.out
	echo
	echo Note that you can reapply the puppet configuration from this directory
	echo with:
	echo	puppet apply --modulepath=modules.go.pp
	echo
}
