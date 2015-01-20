class alfresco::install::alfresco-ce inherits alfresco::install {

  case ($alfresco_version){
      '4.2.f', '4.2.x': {

    

        exec { "retrieve-alfresco-ce":
          command => "wget -q ${urls::alfresco_ce_url} -O ${download_path}/${urls::alfresco_ce_filename}	",
          path => "/usr/bin",
          creates => "${download_path}/${urls::alfresco_ce_filename}",
          timeout => 0,
          require => File[$download_path],
        }

        file { "${download_path}/alfresco":
          ensure => directory,
        }

        exec { "unpack-alfresco-ce":
          command => "unzip -o ${download_path}/${urls::alfresco_ce_filename} -d ${download_path}/alfresco",
          path => "/usr/bin",
          require => [ 
            Exec["retrieve-alfresco-ce"],
            Exec["copy tomcat to ${tomcat_home}"], 
            Package["unzip"], 
            File["${download_path}/alfresco"],
          ],
          creates => "${download_path}/alfresco/README.txt",
        }


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



      }
      '5.0.c', '5.0.x': {
	      exec { "${tomcat_home}/webapps/alfresco.war":
          command => "wget ${urls::alfresco_war_50x} -O alfresco.war",
          cwd => "${tomcat_home}/webapps/",
          path => "/usr/bin",
          creates => "${tomcat_home}/webapps/alfresco.war",
          require => File["${tomcat_home}/webapps/"],
        }

	      exec { "${tomcat_home}/webapps/share.war":
          command => "wget ${urls::share_war_50x} -O share.war",
          cwd => "${tomcat_home}/webapps/",
          path => "/usr/bin",
          creates => "${tomcat_home}/webapps/share.war",
          require => File["${tomcat_home}/webapps/"],
        }

        file { "${tomcat_home}/webapps":
          ensure => directory,
          require => File["${tomcat_home}"],
        }
        

        exec { "unpack-alfresco-ce":
          command => '/bin/true',
        }
      }
  }




	exec { "unpack-alfresco-war": 
		require => [
			Exec["${tomcat_home}/webapps/alfresco.war"],
      Exec['apply-addons'],
		],
    before => Service['alfresco-start'],
		path => "/bin:/usr/bin",
		command => "unzip -o -d ${tomcat_home}/webapps/alfresco ${tomcat_home}/webapps/alfresco.war && chown -R tomcat7 ${tomcat_home}/webapps/alfresco", 
		creates => "${tomcat_home}/webapps/alfresco/",
	}

	exec { "unpack-share-war": 
		require => [
			Exec["${tomcat_home}/webapps/share.war"],
      Exec['apply-addons'],
		],
    before => Service['alfresco-start'],
		path => "/bin:/usr/bin",
		command => "unzip -o -d ${tomcat_home}/webapps/share ${tomcat_home}/webapps/share.war && chown -R tomcat7 ${tomcat_home}/webapps/share", 
		creates => "${tomcat_home}/webapps/share/",
	}

}
