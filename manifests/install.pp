class alfresco::install inherits alfresco {

  class { 'alfresco::install::alfresco-ce': }
  class { 'alfresco::install::postfix': }
  class { 'alfresco::install::mysql': }
  class { 'alfresco::install::proxy': }
  class { 'alfresco::install::iptables': }


	file { $download_path:
		ensure => "directory",
		before => Exec["retrieve-tomcat"],
    owner => 'tomcat',
	}

	# By default the logs go where alfresco starts from, and in this case
	# that is ${tomcat_home}, so we need to create the files and give
	# them write access for the tomcat user
	file { "${tomcat_home}/alfresco.log":
		ensure => present,
		owner => "tomcat",
		group => "tomcat",
		require => [
			Exec["copy tomcat to ${tomcat_home}"],
			User["tomcat"],
		],
	}
	file { "${tomcat_home}/share.log":
		ensure => present,
		owner => "tomcat",
		group => "tomcat",
		require => [
			Exec["copy tomcat to ${tomcat_home}"],
			User["tomcat"],
		],
	}
	user { "tomcat":
		ensure => present,
		before => [ 
			Exec["unpack-alfresco-war"],
			Exec["unpack-share-war"],
		],
	}

#  # the war files
#  exec { "${tomcat_home}/webapps/alfresco.war":
#    command => "cp ${alfresco_war_loc}/alfresco.war ${tomcat_home}/webapps/alfresco.war",
#    require => Exec["unpack-alfresco-ce"],
#    creates => "${tomcat_home}/webapps/alfresco.war",
#    path => '/bin:/usr/bin',
#  }
#  exec { "${tomcat_home}/webapps/share.war":
#    command => "cp ${alfresco_war_loc}/share.war ${tomcat_home}/webapps/share.war",
#    require => Exec["unpack-alfresco-ce"],
#    creates => "${tomcat_home}/webapps/share.war",
#    path => '/bin:/usr/bin',
#  }







	# files under tomcat home

	file{"${tomcat_home}/shared/lib":
		ensure => directory,
    owner => 'tomcat',
	}

	file { "${tomcat_home}/shared":
		ensure => directory,
		require => Exec["copy tomcat to ${tomcat_home}"],
    owner => 'tomcat',
	}

	file { "${tomcat_home}/shared/classes":
		ensure => directory,
		require => File["${tomcat_home}/shared"],
    owner => 'tomcat',
	}

	file { "${tomcat_home}/shared/classes/alfresco":
		ensure => directory,
		require => File["${tomcat_home}/shared/classes"],
    owner => 'tomcat',
	}

	file { "${tomcat_home}/shared/classes/alfresco/web-extension":
		require => File["${tomcat_home}/shared/classes"],
		ensure => directory,
    owner => 'tomcat',
	}


#	exec { "retrieve-alfresco-ce":
#		command => "wget -q ${urls::alfresco_ce_url} -O ${download_path}/${urls::alfresco_ce_filename}	",
#		path => "/usr/bin",
#		creates => "${download_path}/${urls::alfresco_ce_filename}",
#        	timeout => 0,
#		require => File[$download_path],
#	}
#
#	file { "${download_path}/alfresco":
#		ensure => directory,
#	}
#
#	exec { "unpack-alfresco-ce":
#		command => "unzip -o ${download_path}/${urls::alfresco_ce_filename} -d ${download_path}/alfresco",
#		path => "/usr/bin",
#		require => [ 
#			Exec["retrieve-alfresco-ce"],
#			Exec["copy tomcat to ${tomcat_home}"], 
#			Package["unzip"], 
#			File["${download_path}/alfresco"],
#		],
#		creates => "${download_path}/alfresco/README.txt",
#	}




	file { "${alfresco_base_dir}/amps":
		ensure => directory,
    owner => 'tomcat',
	}
	file { "${alfresco_base_dir}/amps_share":
		ensure => directory,
    owner => 'tomcat',
	}


	exec { "retrieve-tomcat":
    user => 'tomcat',
		creates => "${download_path}/${urls::filename_tomcat}",
		command => "wget ${urls::url_tomcat} -O ${download_path}/${urls::filename_tomcat}",
		path => "/usr/bin",
    timeout => 0,
	}

	exec { "unpack-tomcat":
    user => 'tomcat',
		cwd => "${download_path}",
		path => "/bin:/usr/bin",
		command => "tar xzf ${download_path}/${urls::filename_tomcat}",
		require => Exec["retrieve-tomcat"],
		creates => "${download_path}/apache-tomcat-7.0.55/NOTICE",
	}

	exec { "copy tomcat to ${tomcat_home}":
    user => 'tomcat',
		command => "mkdir -p ${tomcat_home} && cp -r ${download_path}/${urls::name_tomcat}/* ${tomcat_home} && chown -R tomcat ${tomcat_home}",
		path => "/bin:/usr/bin",
		provider => shell,		
		require => [ Exec["unpack-tomcat"], User["tomcat"], ],
		creates => "${tomcat_home}/RUNNING.txt",
	}


	file { "${tomcat_home}/conf":
		ensure => directory,
		require => Exec['unpack-tomcat'],
    owner => 'tomcat',
	}

	file { "${tomcat_home}/conf/Catalina":
		ensure => directory,
		require => [
			File["${tomcat_home}/conf"],
		],
    owner => 'tomcat',
	}

	file { "${tomcat_home}/conf/Catalina/localhost":
		ensure => directory,
		require => [
			File["${tomcat_home}/conf/Catalina"],
		],
    owner => 'tomcat',
	}

	#file { "${tomcat_home}/conf/Catalina/localhost/solr.xml":
	#	content => template("alfresco/solr.xml.erb"),
	#}

	file { "${alfresco_base_dir}":
		ensure => directory,
		owner => "tomcat",
		require => [ 
			User["tomcat"], 
		],
	}

	file { "${alfresco_base_dir}/bin":
		ensure => directory,
		require => File["${alfresco_base_dir}"],
		owner => "tomcat",
	}

	file { "${alfresco_base_dir}/bin/limitconvert.sh":
		ensure => present,
		mode => '0755',
		owner => 'tomcat',
		source => 'puppet:///modules/alfresco/limitconvert.sh',
	}

	# XALAN

	$xalan = 'http://svn.alfresco.com/repos/alfresco-open-mirror/alfresco/COMMUNITYTAGS/V4.2f/root/projects/3rd-party/lib/xalan-2.7.0/'

	file { "${tomcat_home}/endorsed":
		ensure => directory,
		require => Exec['unpack-tomcat'],
    owner => 'tomcat',
	}

	exec { 'retrieve-xalan-xalan-jar':
    user => 'tomcat',
		command => "wget ${xalan}/xalan.jar",
		path => '/usr/bin',
		cwd => "${tomcat_home}/endorsed",
		creates => "${tomcat_home}/endorsed/xalan.jar",
		require => File["${tomcat_home}/endorsed"],
	}

	exec { 'retrieve-xalan-serializer-jar':
    user => 'tomcat',
		command => "wget ${xalan}/serializer.jar",
		path => '/usr/bin',
		cwd => "${tomcat_home}/endorsed",
		creates => "${tomcat_home}/endorsed/serializer.jar",
		require => File["${tomcat_home}/endorsed"],
	}



  file { '/etc/sysctl.conf':
    source => 'puppet:///modules/alfresco/sysctl.conf',
    ensure => present,
  }

  file { '/etc/security/limits.conf':
    source => 'puppet:///modules/alfresco/limits.conf',
    ensure => present,
  }


	

	file { "${alfresco_base_dir}/alf_data/keystore":
		ensure => directory,
		require => File["${alfresco_base_dir}/alf_data"],
		owner => "tomcat",
	}
	file { "${alfresco_base_dir}/alf_data":
		ensure => directory,
		require => File["${alfresco_base_dir}"],
		owner => "tomcat",
	}






	file { "${tomcat_home}/common":
		ensure => directory,
		require => File[$tomcat_home],
    owner => 'tomcat',
	}

	file { "$tomcat_home":
		ensure => directory,
    owner => 'tomcat',
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
      timeout => 0,
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
			User["tomcat"], 
		],
		user => "tomcat",
	}	


	exec { "retrieve-loffice":
    user => 'tomcat',
		cwd => $download_path,
		command => "wget -v ${loffice_dl}",
		creates => "${download_path}/${loffice_name}.tar.gz",
		path => "/usr/bin",
		timeout => 0,
    logoutput => true, # or else travis can get upset that nothing has happened for 10 mins :-!
	}

	exec { "unpack-loffice":
    user => 'tomcat',
		cwd => $download_path,
		command => "tar xzvf ${download_path}/${loffice_name}.tar.gz",
		path => "/bin:/usr/bin",
		creates => "${download_path}/${loffice_name}",
		require => Exec["retrieve-loffice"],
    timeout => 0,
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
			$swfpkgs = [
				"ImageMagick",
				"zlib-devel",
				"libjpeg-turbo-devel",
				"giflib-devel",
			        "freetype-devel",
				"gcc",
			        "gcc-c++"
			]
			
			# TODO use this https://github.com/example42/puppi/blob/master/manifests/netinstall.pp

                        exec { "retrieve-swftools":
        user => 'tomcat',
                                command => "wget ${urls::swftools_src_url}",
                    timeout => 0,
                                cwd => $download_path,
                                path => "/usr/bin",
                                creates => "${download_path}/${urls::swftools_src_name}.tar.gz",
                        }


                        exec { "unpack-swftools":
        user => 'tomcat',
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
        user => 'tomcat',
				command => "wget ${urls::swftools_src_url}",
		    timeout => 0,
				cwd => $download_path,
				path => "/usr/bin",		
				creates => "${download_path}/${urls::swftools_src_name}.tar.gz",
			}

		
			exec { "unpack-swftools":
        user => 'tomcat',
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
    	}
	
}

