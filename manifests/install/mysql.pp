class alfresco::install::mysql inherits alfresco {

  if $db_host == 'localhost'  {
	  class { '::mysql::server':
		  root_password    => $db_root_password,
 #     remove_default_accounts=> true,
      service_enabled => true,
      override_options => {
        'mysqld' => {
          'max_connections' => 300,
          'innodb_buffer_pool_size' => '4GB',
          'innodb_log_buffer_size' => 50331648,
          'innodb_log_file_size' => 31457280,
          'innodb_flush_neighbors' => 0,
        
        }
      }
	  } 

	  mysql::db { "$alfresco_db_name":
		  user     => "${alfresco_db_user}",
		  password => "${alfresco_db_pass}",
		  host     => "${alfresco_db_host}",
		  grant    => ['ALL'],
	  }
  }

	class { '::mysql::bindings':
		java_enable => 1,
	}

	exec { "retrieve-mysql-connector":
    user => 'tomcat7',
		command => "wget ${urls::mysql_connector_url}",
		cwd => "${download_path}",
		path => "/usr/bin",
		creates => "${download_path}/${urls::mysql_connector_file}",
	}

	exec { "unpack-mysql-connector":
    user => 'tomcat7',
		command => "tar xzvf ${urls::mysql_connector_file}",
		cwd => $download_path,
		path => "/bin",
		require => Exec["retrieve-mysql-connector"],
		creates => "${download_path}/${urls::mysql_connector_name}",
	}

	exec { "copy-mysql-connector":
    user => 'tomcat7',
		command => "cp ${download_path}/${urls::mysql_connector_name}/${urls::mysql_connector_name}-bin.jar  ${tomcat_home}/shared/lib/",
		path => "/bin:/usr/bin",
		require => [
			Exec["unpack-mysql-connector"],
			File["${tomcat_home}/shared/lib"],
		],
		creates => "${tomcat_home}/shared/lib/${urls::mysql_connector_name}-bin.jar",
	}

}
