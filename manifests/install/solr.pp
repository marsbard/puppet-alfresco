class alfresco::install::solr inherits alfresco {

  case ($alfresco_version) {
    '4.2.f': {

	    exec { "retrieve-solr":
		    command => "wget ${urls::solr_dl} -O solr.zip",
		    cwd => $download_path,
		    path => "/usr/bin",
		    creates => "${download_path}/solr.zip",
	    }

	    exec { "unpack-solr":
		    command => "unzip ${download_path}/solr.zip -d solr/",
		    cwd => $alfresco_base_dir,
		    path => '/usr/bin',
		    creates => "${alfresco_base_dir}/solr/solr.xml",
		    require => [
		  	  Exec["retrieve-solr"],
		    ],
        user => 'tomcat7',
	    }

	    file { "${alfresco_base_dir}/solr/alf_data":
		    ensure => absent,
		    force => true,
		    require => Exec["unpack-alfresco-ce"],
		    before => Service["tomcat7"],
	    }


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

    }


    '5.0.c', '5.0.x', 'NIGHTLY': {

      exec { "retrieve-solr-war":
		    command => "wget ${urls::solr_war_dl} -O solr4.war",
    		cwd => "${tomcat_home}/webapps",
		    path => "/usr/bin",
    		creates => "${tomcat_home}/webapps/solr4.war",
      }

      file { "${alfresco_base_dir}/solr4":
        ensure => directory,
        require => File[$alfresco_base_dir],
        owner => 'tomcat7',
      }
      file { "${alfresco_base_dir}/alf_data/solr4":
        ensure => directory,
        require => File[$alfresco_base_dir],
        owner => 'tomcat7',
      }

      exec { "retrieve-solr-cfg":
        command => "wget ${urls::solr_cfg_dl} -O solrconfig.zip",
    		cwd => $download_path,
		    path => '/usr/bin',
    		creates => "${download_path}/solrconfig.zip",
        #require => File["${alfresco_base_dir}/solr4"],
      }

      exec { "unpack-solr-cfg":
        command => "unzip -o ${download_path}/solrconfig.zip",
    		cwd => "${alfresco_base_dir}/solr4",
		    path => '/usr/bin',
    		creates => "${alfresco_base_dir}/solr4/context.xml",
        require => Exec['retrieve-solr-cfg'],
        notify => Service['tomcat7'],
        user => 'tomcat7',
      }


      file { "${tomcat_home}/conf/Catalina/localhost/solr4.xml":
        content => template('alfresco/solr4.xml.erb'),
        ensure => present,
        require => Exec['unpack-solr-cfg'],
        owner => 'tomcat7',
      }

      file { "${alfresco_base_dir}/solr4/workspace-SpacesStore/conf/solrcore.properties":
        ensure => present,
        content => template('alfresco/solr4core-workspace.properties.erb'),
        require => Exec['unpack-solr-cfg'],
        before => Service['alfresco-start'],
        owner => 'tomcat7',
      }

      file { "${alfresco_base_dir}/solr4/archive-SpacesStore/conf/solrcore.properties":
        ensure => present,
        content => template('alfresco/solr4core-archive.properties.erb'),
        require => Exec['unpack-solr-cfg'],
        before => Service['alfresco-start'],
        owner => 'tomcat7',
      }

    }



  }
}
