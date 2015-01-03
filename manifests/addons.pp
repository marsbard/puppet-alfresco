class alfresco::addons inherits alfresco {

	include alfresco::addons::jsconsole



	exec { "apply-addons":
    require => [
      File["${alfresco_base_dir}/bin/apply_amps.sh"],
			File["${alfresco_base_dir}/bin/alfresco-mmt.jar"],
    ],
    path => "/bin:/usr/bin",
    command => "${alfresco_base_dir}/bin/apply_amps.sh",
    notify => Exec["fix-war-permissions"],
    onlyif => "test ! -f ${tomcat_home}/webapps/alfresco*.bak",
  }

  file { "${alfresco_base_dir}/bin/apply_amps.sh":
    ensure => present,
    mode => "0755",
    content => template("alfresco/apply_amps.sh.erb"),
    require => File["${alfresco_base_dir}/bin"],
  }

	file { "${alfresco_base_dir}/bin/clean_tomcat.sh":
		ensure => present,
		mode => '0755',
		source => "${download_path}/alfresco/bin/clean_tomcat.sh",
    require => File["${alfresco_base_dir}/bin"],
    owner => 'tomcat7',
  }
 
  file { "${alfresco_base_dir}/bin/iptables.sh":
    source => 'puppet:///modules/alfresco/iptables.sh',
    ensure => present,
    require => File["${alfresco_base_dir}/bin"],
    mode => '0755',
    owner => 'tomcat7',
  }

	file { "${alfresco_base_dir}/bin/alfresco-mmt.jar":
		ensure => present,
		mode => '0755',
		source => "${download_path}/alfresco/bin/alfresco-mmt.jar",
    require => File["${alfresco_base_dir}/bin"],
	}

  exec { "fix-war-permissions":
    path => "/bin:/usr/bin",
    command => "chown tomcat7 ${tomcat_home}/webapps/*.war; chmod a+r ${tomcat_home}/webapps/*.war",
    onlyif => [
      "test -f ${tomcat_home}/webapps/alfresco.war  && ls -l ${tomcat_home}/webapps/alfresco.war | xargs | cut -f3 -d\  | grep tomcat7",
      "test -f ${tomcat_home}/webapps/share.war  && ls -l ${tomcat_home}/webapps/share.war | xargs | cut -f3 -d\  | grep tomcat7",
      "test -r ${tomcat_home}/webapps/alfresco.war",
      "test -r ${tomcat_home}/webapps/share.war",
    ]
  }

}
