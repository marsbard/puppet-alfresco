class alfresco::install::mysql inherits alfresco {


  if($alfresco_db_host != 'localhost') {

	  class { '::mysql::server':
		  #root_password    => $db_root_password,
	  }

    # for some reason setting it above does not always(?) work
    exec { "Set MySQL server root password":
      subscribe => [ Class["::mysql::server"] ],
      refreshonly => true,
      unless => "mysqladmin -uroot -p$db_root_password status",
      path => "/bin:/usr/bin",
      command => "mysqladmin -uroot password $db_root_password",
    }

  }



	mysql::db { "$alfresco_db_name":
		user     => "${alfresco_db_user}",
		password => "${alfresco_db_pass}",
		host     => "${alfresco_db_host}",
		grant    => ['ALL'],
	}


	class { '::mysql::bindings':
		java_enable => 1,
	}


	exec { "retrieve-mysql-connector":
		command => "wget ${urls::mysql_connector_url}",
		cwd => "${download_path}",
		path => "/usr/bin",
		creates => "${download_path}/${urls::mysql_connector_file}",
	}

	exec { "unpack-mysql-connector":
		command => "tar xzvf ${urls::mysql_connector_file}",
		cwd => $download_path,
		path => "/bin",
		require => Exec["retrieve-mysql-connector"],
		creates => "${download_path}/${urls::mysql_connector_name}",
	}

	exec { "copy-mysql-connector":
		command => "cp ${download_path}/${urls::mysql_connector_name}/${urls::mysql_connector_name}-bin.jar  ${tomcat_home}/shared/lib/",
		path => "/bin:/usr/bin",
		require => [
			Exec["unpack-mysql-connector"],
			File["${tomcat_home}/shared/lib"],
		],
		creates => "${tomcat_home}/shared/lib/${urls::mysql_connector_name}-bin.jar",
	}

}