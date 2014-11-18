class alfresco::install inherits alfresco {


  	case $::osfamily {
    		'RedHat': {
			$jdkpackage = "java-1.7.0-openjdk"
		}
		'Debian': {
			$jdkpackage = "openjdk-7-jdk"
			exec { "apt-update":
			    	command => "/usr/bin/apt-get update",
				schedule => "nightly",
			}
		}
		default:{
			exit("Unsupported osfamily $osfamily")
		} 
	}

	schedule { 'nightly':
		period => daily,
		range  => "2 - 4",
	}






    	$packages = [ 
		"git", 
		$jdkpackage,
 		"unzip",
		"curl",
 	] 
    
	# this for debian-ish systems. kind of irrelevant for centos etc but doesn't hurt
	$rmpackages = [ 
		"openjdk-6-jdk",
 		"openjdk-6-jre-lib",
	]

    	package { $packages:
        	ensure => "installed", 
    	}

	package { $rmpackages:
		ensure => "absent",
	}


	class { '::mysql::server':
		  root_password    => $db_root_password,
	}

	mysql::db { "$alfresco_db_name":
		user     => "${alfresco_db_user}",
		password => "${alfresco_db_pass}",
		host     => "${alfresco_db_host}",
		grant    => ['ALL'],
	}


	class { '::mysql::bindings':
		java_enable => 1,
	}



	file { $download_path:
		ensure => "directory",
		before => Exec["retrieve-tomcat7"],
	}

	# By default the logs go where alfresco starts from, and in this case
	# that is ${tomcat_home}, so we need to create the files and give
	# them write access for the tomcat7 user
	file { "${tomcat_home}/alfresco.log":
		ensure => present,
		owner => "tomcat7",
		require => [
			Exec["copy tomcat to ${tomcat_home}"],
			User["tomcat7"],
		],
	}
	file { "${tomcat_home}/share.log":
		ensure => present,
		owner => "tomcat7",
		require => [
			Exec["copy tomcat to ${tomcat_home}"],
			User["tomcat7"],
		],
	}
	user { "tomcat7":
		ensure => present,
		before => [ 
			Exec["unpack-alfresco-war"],
			Exec["unpack-share-war"],
		],
	}





	# the war files
	file { "${tomcat_home}/webapps/alfresco.war":
		source => "${alfresco_war_loc}/alfresco.war",
		require => Exec["unzip-alfresco-ce"],
		ensure => present,
	}
	file { "${tomcat_home}/webapps/share.war":
		source => "${alfresco_war_loc}/share.war",
		require => Exec["unzip-alfresco-ce"],
		ensure => present,
	}

	exec { "unpack-alfresco-war": 
		require => [
			File["${tomcat_home}/webapps/alfresco.war"],
		],
		path => "/bin:/usr/bin",
		command => "unzip -o -d ${tomcat_home}/webapps/alfresco ${tomcat_home}/webapps/alfresco.war && chown -R tomcat7 ${tomcat_home}/webapps/alfresco", 
		creates => "${tomcat_home}/webapps/alfresco/",
	}

	exec { "unpack-share-war": 
		require => [
			File["${tomcat_home}/webapps/share.war"],
		],
		path => "/bin:/usr/bin",
		command => "unzip -o -d ${tomcat_home}/webapps/share ${tomcat_home}/webapps/share.war && chown -R tomcat7 ${tomcat_home}/webapps/share", 
		creates => "${tomcat_home}/webapps/share/",
	}




	# files under tomcat home
	file { "${tomcat_home}/shared/classes":
		ensure => directory,
		require => File["${tomcat_home}/shared"],
	}
	file{"${tomcat_home}/shared/lib":
		ensure => directory,
	}

	file { "${tomcat_home}/shared":
		ensure => directory,
		require => Exec["copy tomcat to ${tomcat_home}"],
	}



	exec { "retrieve-alfresco-ce":
		command => "wget -q ${alfresco_ce_url} -O ${download_path}/${alfresco_ce_filename}	",
		path => "/usr/bin",
		creates => "${download_path}/${alfresco_ce_filename}",
        	timeout => 0,
		require => File[$download_path],
	}

	file { "${download_path}/alfresco":
		ensure => directory,
	}

	exec { "unzip-alfresco-ce":
		command => "unzip -o ${download_path}/${alfresco_ce_filename} -d ${download_path}/alfresco",
		path => "/usr/bin",
		require => [ 
			Exec["retrieve-alfresco-ce"],
			Exec["copy tomcat to ${tomcat_home}"], 
			Package["unzip"], 
			File["${download_path}/alfresco"],
		],
		creates => "${download_path}/alfresco/README.txt",
	}




	file { "${alfresco_base_dir}/amps":
		ensure => directory,
	}
	file { "${alfresco_base_dir}/amps_share":
		ensure => directory,
	}




	exec { "retrieve-tomcat7":
		creates => "${download_path}/$filename_tomcat",
		command => "wget $url_tomcat -O ${download_path}/$filename_tomcat",
		path => "/usr/bin",
	}

	exec { "unpack-tomcat7":
		cwd => "${download_path}",
		path => "/bin:/usr/bin",
		command => "tar xzf ${download_path}/$filename_tomcat",
		require => Exec["retrieve-tomcat7"],
		creates => "${download_path}/apache-tomcat-7.0.55/NOTICE",
	}

	exec { "copy tomcat to ${tomcat_home}":
		command => "mkdir -p ${tomcat_home} && cp -r ${download_path}/${name_tomcat}/* ${tomcat_home} && chown -R tomcat7 ${tomcat_home}",
		path => "/bin:/usr/bin",
		provider => shell,		
		require => [ Exec["unpack-tomcat7"], User["tomcat7"], ],
		creates => "${tomcat_home}/RUNNING.txt",
	}










	file { "${alfresco_base_dir}":
		ensure => directory,
		owner => "tomcat7",
		require => [ 
			User["tomcat7"], 
		],
	}

	file { "${alfresco_base_dir}/solr":
		ensure => directory,
		owner => "tomcat7",
		require => [ 
			File[$alfresco_base_dir],	
		],
	}

	exec { "retrieve-solr":
		command => "wget ${solr_dl} -O solr.zip",
		cwd => $download_path,
		path => "/usr/bin",
		creates => "${download_path}/solr.zip",
	}

	exec { "unpack-solr":
		command => "unzip solr.zip -d solr/",
		cwd => $download_path,
		path => "/usr/bin",
		creates => "${download_path}/solr/",
		require => Exec["retrieve-solr"],
	}


	exec { "retrieve-mysql-connector":
		command => "wget $mysql_connector_url",
		cwd => "${download_path}",
		path => "/usr/bin",
		creates => "${download_path}/${mysql_connector_file}",
	}

	exec { "unpack-mysql-connector":
		command => "tar xzvf $mysql_connector_file",
		cwd => $download_path,
		path => "/bin",
		require => Exec["retrieve-mysql-connector"],
		creates => "${download_path}/${mysql_connector_name}",
	}

	exec { "copy-mysql-connector":
		command => "cp ${download_path}/${mysql_connector_name}/${mysql_connector_name}-bin.jar  ${tomcat_home}/shared/lib/",
		path => "/bin:/usr/bin",
		require => [
			Exec["unpack-mysql-connector"],
			File["${tomcat_home}/shared/lib"],
		],
		creates => "${tomcat_home}/shared/lib/${mysql_connector_name}-bin.jar",
	}

	

	file { "${alfresco_base_dir}/alf_data/keystore":
		ensure => directory,
		require => File["${alfresco_base_dir}/alf_data"],
		owner => "tomcat7",
	}
	file { "${alfresco_base_dir}/alf_data":
		ensure => directory,
		require => File["${alfresco_base_dir}"],
		owner => "tomcat7",
	}

	file { "${tomcat_home}/common":
		ensure => directory,
		require => File[$tomcat_home],
	}

	file { "$tomcat_home":
		ensure => directory,
	}


	# keystore files

	# http://projects.puppetlabs.com/projects/1/wiki/Download_File_Recipe_Patterns
	define download_file(
		$site="",
		$cwd="",
		$creates="",
		$require="",
		$user="") {                                                                                         

		exec { $name:                                                                                                                     
			command => "wget ${site}/${name}",    
			path => "/usr/bin",                                                     
			cwd => $cwd,
			creates => "${cwd}/${name}",                                                              
			require => $require,
			user => $user,                                                                                                          
		}

	}

	download_file { [
		"browser.p12",
		"generate_keystores.sh",
		"keystore",
		"keystore-passwords.properties",
		"ssl-keystore-passwords.properties",
		"ssl-truststore-passwords.properties",
		"ssl.keystore",
		"ssl.truststore",
	]:
		site => "$keystorebase",
		cwd => "${alfresco_base_dir}/alf_data/keystore",
		creates => "${alfresco_base_dir}/alf_data/keystore/${name}",
		require => [ 
			User["tomcat7"], 
		],
		user => "tomcat7",
	}	


	exec { "retrieve-loffice":
		cwd => $download_path,
		command => "wget $loffice_dl",
		creates => "${download_path}/${loffice_name}.tar.gz",
		path => "/usr/bin",
		timeout => 0,
	}

	exec { "unpack-loffice":
		cwd => $download_path,
		command => "tar xzvf ${download_path}/${loffice_name}.tar.gz",
		path => "/bin:/usr/bin",
		creates => "${download_path}/${loffice_name}",
		require => Exec["retrieve-loffice"],
	}

	case $::osfamily {
    		'RedHat': {
			$pkgdir = "${download_path}/${loffice_name}/RPMS"
			$instcmd = "yum localinstall *.rpm"
		}
		'Debian': {
			$pkgdir = "${download_path}/${loffice_name}/DEBS"
			$instcmd = "dpkg -i *.deb"
		}
		default:{
			exit("Unsupported osfamily $osfamily")
		} 
	}

	exec { "install-loffice":
		logoutput => true,
		command => $instcmd,
		cwd => $pkgdir,
		path => "/bin:/usr/bin:/sbin:/usr/sbin",
		require => Exec["unpack-loffice"],
		creates => "${lo_install_loc}",
		
	}

}
