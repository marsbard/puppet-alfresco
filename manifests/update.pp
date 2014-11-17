class alfresco::update {

  	case $::osfamily {
    		'Debian': {
			$updatecmd = "apt-get update; apt-get upgrade -y"
		}
		'RedHat': {
			$updatecmd = "yum -y upgrade"
		}
		default:{
			exit("Unsupported osfamily $osfamily")
		} 
	}




	exec { "update-before-alfresco":
		command => "$updatecmd",
		path => "/bin:/usr/bin:/sbin:/usr/sbin",	
	}


}
