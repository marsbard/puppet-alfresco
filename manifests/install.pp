class alfresco::install inherits alfresco {


  class { 'alfresco::install::alfresco-ce':
  }


	class { '::mysql::server':
		#bind_address => '0.0.0.0',
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










	# files under tomcat home

	file{"${tomcat_home}/shared/lib":
		ensure => directory,
	}

	file { "${tomcat_home}/shared":
		ensure => directory,
		require => Exec["copy tomcat to ${tomcat_home}"],
	}

	file { "${tomcat_home}/shared/classes":
		ensure => directory,
		require => File["${tomcat_home}/shared"],
	}

	file { "${tomcat_home}/shared/classes/alfresco":
		ensure => directory,
		require => File["${tomcat_home}/shared/classes"],
	}

	file { "${tomcat_home}/shared/classes/alfresco/web-extension":
		require => File["${tomcat_home}/shared/classes"],
		ensure => directory,
	}





	file { "${alfresco_base_dir}/amps":
		ensure => directory,
	}
	file { "${alfresco_base_dir}/amps_share":
		ensure => directory,
	}


	exec { "retrieve-tomcat7":
		creates => "${download_path}/${urls::filename_tomcat}",
		command => "wget ${urls::url_tomcat} -O ${download_path}/${urls::filename_tomcat}",
		path => "/usr/bin",
	}

	exec { "unpack-tomcat7":
		cwd => "${download_path}",
		path => "/bin:/usr/bin",
		command => "tar xzf ${download_path}/${urls::filename_tomcat}",
		require => Exec["retrieve-tomcat7"],
		creates => "${download_path}/apache-tomcat-7.0.55/NOTICE",
	}

	exec { "copy tomcat to ${tomcat_home}":
		command => "mkdir -p ${tomcat_home} && cp -r ${download_path}/${urls::name_tomcat}/* ${tomcat_home} && chown -R tomcat7 ${tomcat_home}",
		path => "/bin:/usr/bin",
		provider => shell,		
		require => [ Exec["unpack-tomcat7"], User["tomcat7"], ],
		creates => "${tomcat_home}/RUNNING.txt",
	}


	file { "${tomcat_home}/conf":
		ensure => directory,
		require => Exec['unpack-tomcat7'],
	}

	file { "${tomcat_home}/conf/Catalina":
		ensure => directory,
		require => [
			File["${tomcat_home}/conf"],
		],
	}

	file { "${tomcat_home}/conf/Catalina/localhost":
		ensure => directory,
		require => [
			File["${tomcat_home}/conf/Catalina"],
		],
	}

	file { "${alfresco_base_dir}":
		ensure => directory,
		owner => "tomcat7",
		require => [ 
			User["tomcat7"], 
		],
	}

	file { "${alfresco_base_dir}/bin":
		ensure => directory,
		require => File["${alfresco_base_dir}"],
		owner => "tomcat7",
	}

	file { "${alfresco_base_dir}/bin/limitconvert.sh":
		ensure => present,
		mode => '0755',
		owner => 'tomcat7',
		source => 'puppet:///modules/alfresco/limitconvert.sh',
	}

	file { "${alfresco_base_dir}/bin/update-admin-passwd.sh":
		ensure => present,
		source => 'puppet:///modules/alfresco/update-admin-passwd.sh',
		owner => 'tomcat7',
		mode => '0755',
	}
	
	file { "${alfresco_base_dir}/bin/show-admin-passwd-hash.sh":
		ensure => present,
		source => 'puppet:///modules/alfresco/show-admin-passwd-hash.sh',
		owner => 'tomcat7',
		mode => '0755',
	}


	$xalan = 'http://svn.alfresco.com/repos/alfresco-open-mirror/alfresco/COMMUNITYTAGS/V4.2f/root/projects/3rd-party/lib/xalan-2.7.0/'

	file { "${tomcat_home}/endorsed":
		ensure => directory,
		require => Exec['unpack-tomcat7'],
	}

	exec { 'retrieve-xalan-xalan-jar':
		command => "wget ${xalan}/xalan.jar",
		path => '/usr/bin',
		cwd => "${tomcat_home}/endorsed",
		creates => "${tomcat_home}/endorsed/xalan.jar",
		require => File["${tomcat_home}/endorsed"],
	}

	exec { 'retrieve-xalan-serializer-jar':
		command => "wget ${xalan}/serializer.jar",
		path => '/usr/bin',
		cwd => "${tomcat_home}/endorsed",
		creates => "${tomcat_home}/endorsed/serializer.jar",
		require => File["${tomcat_home}/endorsed"],
	}


	exec { "retrieve-mysql-connector":
		command => "wget ${urls::mysql_connector_url}",
		cwd => "${download_path}",
		path => "/usr/bin",
		creates => "${download_path}/${urls::mysql_connector_file}",
	}

	exec { "unpack-mysql-connector":
		command => "tar xzvf ${urls::mysql_connector_file}",
		cwd => $download_path,
		path => "/bin",
		require => Exec["retrieve-mysql-connector"],
		creates => "${download_path}/${urls::mysql_connector_name}",
	}

	exec { "copy-mysql-connector":
		command => "cp ${download_path}/${urls::mysql_connector_name}/${urls::mysql_connector_name}-bin.jar  ${tomcat_home}/shared/lib/",
		path => "/bin:/usr/bin",
		require => [
			Exec["unpack-mysql-connector"],
			File["${tomcat_home}/shared/lib"],
		],
		creates => "${tomcat_home}/shared/lib/${urls::mysql_connector_name}-bin.jar",
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
		command => "wget ${loffice_dl}",
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

			exec { "install-loffice":
				command => "yum -y localinstall *.rpm",
				cwd => "${download_path}/${loffice_name}/RPMS",
				path => "/bin:/usr/bin:/sbin:/usr/sbin",
				require => Exec["unpack-loffice"],
				creates => "${lo_install_loc}",
		
			}

		}
		'Debian': {


			exec { "install-loffice":
				command => "dpkg -i *.deb",
				cwd => "${download_path}/${loffice_name}/DEBS",
				path => "/bin:/usr/bin:/sbin:/usr/sbin",
				require => Exec["unpack-loffice"],
				creates => "${lo_install_loc}",
		
			}

		}
		default:{
			fail("Unsupported osfamily $osfamily")
		} 
	}
	


##################################################
# trying to keep swftools config separate in case I can find a build with pdf2swf in
###################################################

	case $::osfamily {
    		'RedHat': {
			$swfpkgs = ["swftools"]
		}
		'Debian': {
			$swfpkgs = [
				"build-essential",
				"ccache", 
				"g++", 
				"libgif-dev", 
				"libjpeg62-dev", 
				"libfreetype6-dev", 
				"libpng12-dev", 
				"libt1-dev",
			]


			# TODO use this https://github.com/example42/puppi/blob/master/manifests/netinstall.pp

			exec { "retrieve-swftools":
				command => "wget ${urls::swftools_src_url}",
				cwd => $download_path,
				path => "/usr/bin",		
				creates => "${download_path}/${urls::swftools_src_name}.tar.gz",
			}

		
			exec { "unpack-swftools":
				command => "tar xzvf ${urls::swftools_src_name}.tar.gz",
				cwd => $download_path,
				path => "/bin:/usr/bin",
				creates => "${download_path}/${urls::swftools_src_name}",
				require => Exec["retrieve-swftools"],
			}


			exec { "build-swftools":
				command => "bash ./configure && make && make install",
				cwd => "${download_path}/${urls::swftools_src_name}",
				path => "/bin:/usr/bin",
				require => [ Exec["unpack-swftools"], Package[$swfpkgs], ],
				creates => "/usr/local/bin/pdf2swf",
			}


		}
		default:{
			fail("Unsupported osfamily $osfamily")
		} 
	}

    	package { $swfpkgs:
        	ensure => "installed",
          #allow_virtual => false,
    	}
	
}

