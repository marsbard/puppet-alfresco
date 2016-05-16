class alfresco::config inherits alfresco {

  $coders_path = find_coders()
  notice("coders_path = ${coders_path}")
  
	case $::osfamily {
        'RedHat': {
      $init_template = "alfresco/tomcat-init-centos.erb"
      
			file { "/etc/systemd":
			 ensure => directory,
			} -> 
			file { "/etc/systemd/system":
				ensure => directory,
			} ->
      file { "/etc/systemd/system/tomcat.service":
        ensure => present,
        content => template("alfresco/tomcat-systemd-centos.erb"),
        before => Service["alfresco-start"],
      }


    }
    'Debian': {
      $init_template = "alfresco/tomcat-init.erb"
    }
    default:{
      fail("Unsupported osfamily $osfamily")
    } 
  }

  if($osfamily == "Debian") {
    # tomcat memory set in here TODO: what TODO for Centos?
    file { "/etc/default/tomcat":
      require => Exec["copy tomcat to ${tomcat_home}"],
      content => template("alfresco/default-tomcat.erb")
    }
  }

  file { "${tomcat_home}/shared/classes/alfresco-global.properties":
    require => File["${tomcat_home}/shared/classes"],
    content => template("alfresco/alfresco-global.properties.erb"),
    ensure => present,
    owner => 'tomcat',
  }

  file { "${tomcat_home}/shared/classes/alfresco/web-extension/share-config-custom.xml":
    require => File["${tomcat_home}/shared/classes/alfresco/web-extension"],
    ensure => present,
    owner => 'tomcat',
    content => template('alfresco/share-config-custom.xml.erb'),
  }

  file { "/etc/init.d/tomcat":
    ensure => present,
    content => template($init_template),
    mode => "0755",
    owner => 'tomcat',
  }

  file { "${tomcat_home}/conf/server.xml":
    ensure => present,
    source => 'puppet:///modules/alfresco/server.xml',
    owner => 'tomcat',
  }

  file { "${tomcat_home}/conf/catalina.properties":
    ensure => present,
    source => 'puppet:///modules/alfresco/catalina.properties',
    owner => 'tomcat',
  }

  
  file { "${tomcat_home}/conf/tomcat-users.xml":
    ensure => present,
    require => Exec['unpack-tomcat'],
    source => 'puppet:///modules/alfresco/tomcat-users.xml',
    owner => 'tomcat',
  }
  
  # admin password

  #exec { "set-admin-password":
  #  command => "${alfresco_base_dir}/bin/update-admin-passwd.sh ${admin_pass} ${db_name} ${db_user} ${db_pass} && touch ${alfresco_base_dir}/.puppet_set_admin_passwd",
  #  path => "/bin:/usr/bin",
  #  creates => "${alfresco_base_dir}/.puppet_set_admin_passwd",
  #  require => Exec["unzip-alfresco_ce"],
  #}



#  # patch file to update admin password
#  file { "${tomcat_home}/webapps/alfresco/WEB-INF/classes/alfresco/dbscripts/upgrade/4.2/org.hibernate.dialect.MySQLInnoDBDialect/admin-passwd-update.sql":
#    content => template("alfresco/admin-passwd-update.sql.erb"),
#    ensure => present,
#    require => Exec["unzip-alfresco_ce"],
#  }


}
