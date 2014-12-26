class alfresco::install::alfresco-ce inherits alfresco::install {

  case ($alfresco_version){
      '4.2.f', '4.2.x': {


	      # the war files
	      exec { "${tomcat_home}/webapps/alfresco.war":
		      command => "cp ${alfresco_war_loc}/alfresco.war ${tomcat_home}/webapps/alfresco.war",
		      require => Exec["unpack-alfresco-ce"],
          creates => "${tomcat_home}/webapps/alfresco.war",
          path => '/bin:/usr/bin',
          notify => Service['tomcat7']
	      }
	      exec { "${tomcat_home}/webapps/share.war":
		      command => "cp ${alfresco_war_loc}/share.war ${tomcat_home}/webapps/share.war",
		      require => Exec["unpack-alfresco-ce"],
          creates => "${tomcat_home}/webapps/share.war",
          path => '/bin:/usr/bin',
          notify => Service['tomcat7']
	      }



	      exec { "unpack-alfresco-war": 
		      require => [
			      Exec["${tomcat_home}/webapps/alfresco.war"],
		      ],
		      path => "/bin:/usr/bin",
		      command => "unzip -o -d ${tomcat_home}/webapps/alfresco ${tomcat_home}/webapps/alfresco.war && chown -R tomcat7 ${tomcat_home}/webapps/alfresco", 
		      creates => "${tomcat_home}/webapps/alfresco/",
	      }

	      exec { "unpack-share-war": 
		      require => [
			      Exec["${tomcat_home}/webapps/share.war"],
		      ],
		      path => "/bin:/usr/bin",
		      command => "unzip -o -d ${tomcat_home}/webapps/share ${tomcat_home}/webapps/share.war && chown -R tomcat7 ${tomcat_home}/webapps/share", 
		      creates => "${tomcat_home}/webapps/share/",
	      }

      }
      '5.0.c', '5.0.x': {

      }
  }


}
