class alfresco::solr inherits alfresco {
	$solr_host = $domain_name


  case ($alfresco_version) {
    '4.2.f', '4.2.x': {
      $solr_dl_file = "alfresco-community-solr-4.2.f.zip"
      $solr_dl = "http://dl.alfresco.com/release/community/4.2.f-build-00012/${solr_dl_file}"
	
      $solr_war_fs_path = "solr/apache-solr-1.4.1.war"
      $solr_home = "solr"

      exec { "retrieve-solr":
		    command => "wget ${solr_dl} -O solr.zip",
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
    '5.0.c', '5.0.x': {

	    $solr_war_file = "alfresco-solr4-5.0.b-ssl.war"
	    $solr_war_dl = "https://artifacts.alfresco.com/nexus/service/local/repo_groups/public/content/org/alfresco/alfresco-solr4/5.0.b/$solr_war_file"
	
	    $solr_cfg_file = "alfresco-solr4-5.0.b-config-ssl.zip"
	    $solr_cfg_dl = "https://artifacts.alfresco.com/nexus/service/local/repo_groups/public/content/org/alfresco/alfresco-solr4/5.0.b/$solr_cfg_file"

      exec { "retrieve-solr-war":
		    command => "wget ${solr_war_dl} -O solr4.war",
    		cwd => "${tomcat_home}/webapps",
		    path => "/usr/bin",
    		creates => "${tomcat_home}/webapps/solr4.war",
      }

      file { "${alfresco_base_dir}/solr4":
        ensure => directory,
        require => File[$alfresco_base_dir],
      }

      exec { "retrieve-solr-cfg":
        command => "wget ${solr_cfg_dl} -O solrconfig.zip",
    		cwd => $download_path,
		    path => '/usr/bin',
    		creates => "${alfresco_base_dir}/solr4/solrconfig.zip",
        require => File["${alfresco_base_dir}/solr4"],
      }

      exec { "unpack-solr-cfg":
        command => "unzip ${download_path}/solrconfig.zip",
    		cwd => "${alfresco_base_dir}/solr4",
		    path => '/usr/bin',
    		creates => "${alfresco_base_dir}/solr4/solrconfig",
        require => Exec['retrieve-solr-cfg"],
        notify => Service['tomcat7'],
      }


      file { "${tomcat_home}/conf/Catalina/localhost/solr4.xml":
        content => template('alfresco/solr4.xml.erb'),
        ensure => present,
      }




    }
  }


}

