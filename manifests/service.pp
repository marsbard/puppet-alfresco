class alfresco::service inherits alfresco {
	service { 'alfresco-start':
		name => 'tomcat7',
		ensure => running,
		enable => true,
		subscribe => [
			File["${tomcat_home}/shared/classes/alfresco-global.properties"],
			File["${tomcat_home}/webapps/alfresco.war"],
			File["${tomcat_home}/webapps/share.war"],
		],
	}

}
