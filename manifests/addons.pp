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
    source => 'puppet:///modules/alfresco/clean_tomcat.sh',
    ensure => present,
    require => File["${alfresco_base_dir}/bin"],
    mode => '0755',
    owner => 'tomcat7',
  }

  file { "${alfresco_base_dir}/bin/alfresco-mmt.jar":
    source => 'puppet:///modules/alfresco/alfresco-mmt.jar',
    ensure => present,
    require => File["${alfresco_base_dir}/bin"],
    mode => '0644',
    owner => 'tomcat7',
  }


  exec { "fix-war-permissions":
    path => "/bin",
    command => "chown tomcat7 ${tomcat_home}/webapps/*.war; chmod a+r ${tomcat_home}/webapps/*.war",
    onlyif => [
      "ls -l ${tomcat_home}/webapps/alfresco.war | xargs | cut -f3 -d\ | grep tomcat7",
      "ls -l ${tomcat_home}/webapps/share.war | xargs | cut -f3 -d\ | grep tomcat7",
      "test -r ${tomcat_home}/webapps/alfresco.war",
      "test -r ${tomcat_home}/webapps/share.war",
    ]
  }

}
