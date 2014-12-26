class alfresco::solr inherits alfresco {
	$solr_host = $domain_name




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
	}

	file { "${alfresco_base_dir}/solr/alf_data":
		ensure => absent,
		force => true,
		require => Exec["unzip-alfresco-ce"],
		before => Service["tomcat7"],
	}

}
