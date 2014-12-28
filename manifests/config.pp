class alfresco::config inherits alfresco {


 	case $::osfamily {
    		'RedHat': {
			$init_template = "alfresco/tomcat7-init-centos.erb"
		}
		'Debian': {
			$init_template = "alfresco/tomcat7-init.erb"
		}
		default:{
			fail("Unsupported osfamily $osfamily")
		} 
	}

	if($osfamily == "Debian") {
		# tomcat memory set in here TODO: what TODO for Centos?
		file { "/etc/default/tomcat7":
			require => Exec["copy tomcat to ${tomcat_home}"],
			content => template("alfresco/default-tomcat7.erb")
		}
	}

	file { "${tomcat_home}/shared/classes/alfresco-global.properties":
		require => File["${tomcat_home}/shared/classes"],
		content => template("alfresco/alfresco-global.properties.erb"),
		ensure => present,
	}

	file { "${tomcat_home}/shared/classes/alfresco/web-extension/share-config-custom.xml":
		require => File["${tomcat_home}/shared/classes/alfresco/web-extension"],
		ensure => present,
		content => template('alfresco/share-config-custom.xml.erb'),
	}

	file { "/etc/init.d/tomcat7":
		ensure => present,
		content => template($init_template),
		mode => "0755",
	}

	file { "${tomcat_home}/conf/server.xml":
		ensure => present,
		source => 'puppet:///modules/alfresco/server.xml',
		owner => 'tomcat7',
	}

	file { "${tomcat_home}/conf/catalina.properties":
		ensure => present,
		source => 'puppet:///modules/alfresco/catalina.properties',
		owner => 'tomcat7',
	}


	# SOLR

	file { "${alfresco_base_dir}/solr/workspace-SpacesStore/conf/solrcore.properties":
		require => Exec['unpack-solr'],
		content => template('alfresco/solrcore-workspace.properties.erb'),
		ensure => present,
	}


	file { "${alfresco_base_dir}/solr/archive-SpacesStore/conf/solrcore.properties":
		require => Exec['unpack-solr'],
		content => template('alfresco/solrcore-archive.properties.erb'),
		ensure => present,
	}

	file { "${tomcat_home}/conf/Catalina/localhost/solr.xml":
                content => template('alfresco/solr.xml.erb'),
		ensure => present,
	}

	file { "${tomcat_home}/conf/tomcat-users.xml":
		ensure => present,
		require => Exec['unpack-tomcat7'],
		source => 'puppet:///modules/alfresco/tomcat-users.xml',
		owner => 'tomcat7',
	}


}
