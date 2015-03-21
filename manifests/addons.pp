class alfresco::addons inherits alfresco {

	include alfresco::addons::rm
	include alfresco::addons::jsconsole


	exec { "apply-addons":
    require => [
      File["${alfresco_base_dir}/bin/apply_amps.sh"],
			File["${alfresco_base_dir}/bin/alfresco-mmt.jar"],
    ],
    path => "/bin:/usr/bin",
    command => "${alfresco_base_dir}/bin/apply_amps.sh",
    onlyif => "test ! -f ${tomcat_home}/webapps/alfresco*.bak",
    user => 'tomcat7',
  }

  file { "${alfresco_base_dir}/bin/apply_amps.sh":
    ensure => present,
    mode => "0755",
    content => template("alfresco/apply_amps.sh.erb"),
    require => File["${alfresco_base_dir}/bin"],
    owner => 'tomcat7',
  }

	file { "${alfresco_base_dir}/bin/clean_tomcat.sh":
		ensure => present,
		mode => '0755',
		#source => "${download_path}/alfresco/bin/clean_tomcat.sh",
    source => 'puppet:///modules/alfresco/clean_tomcat.sh',
    require => File["${alfresco_base_dir}/bin"],
    owner => 'tomcat7',
  }
 
	file { "${alfresco_base_dir}/bin/alfresco-mmt.jar":
		ensure => present,
		mode => '0755',
		#source => "${download_path}/alfresco/bin/alfresco-mmt.jar",
    source => 'puppet:///modules/alfresco/alfresco-mmt.jar',
    require => File["${alfresco_base_dir}/bin"],
    owner => 'tomcat7',
	}

  #exec { "fix-war-permissions":
  #  path => "/bin:/usr/bin",
  #  command => "chown tomcat7 ${tomcat_home}/webapps/*.war; chmod a+r ${tomcat_home}/webapps/*.war",
  #  onlyif => [
  #    "test -f ${tomcat_home}/webapps/alfresco.war  && ls -l ${tomcat_home}/webapps/alfresco.war | xargs | cut -f3 -d\  | grep tomcat7",
  #    "test -f ${tomcat_home}/webapps/share.war  && ls -l ${tomcat_home}/webapps/share.war | xargs | cut -f3 -d\  | grep tomcat7",
  #    "test -r ${tomcat_home}/webapps/alfresco.war",
  #    "test -r ${tomcat_home}/webapps/share.war",
  #  ]
  #}

#	exec { "unpack-alfresco-war": 
#		require => [
#			Exec["${tomcat_home}/webapps/alfresco.war"],
#      Exec['apply-addons'],
#		],
#		path => "/bin:/usr/bin",
#		command => "unzip -o -d ${tomcat_home}/webapps/alfresco ${tomcat_home}/webapps/alfresco.war && chown -R tomcat7 ${tomcat_home}/webapps/alfresco", 
#		creates => "${tomcat_home}/webapps/alfresco/",
#    notify => Service['tomcat7'],
#	}
#
#	exec { "unpack-share-war": 
#		require => [
#			Exec["${tomcat_home}/webapps/share.war"],
#      Exec['apply-addons'],
#		],
#		path => "/bin:/usr/bin",
#		command => "unzip -o -d ${tomcat_home}/webapps/share ${tomcat_home}/webapps/share.war && chown -R tomcat7 ${tomcat_home}/webapps/share", 
#		creates => "${tomcat_home}/webapps/share/",
#    notify => Service['tomcat7'],
#	}

}
