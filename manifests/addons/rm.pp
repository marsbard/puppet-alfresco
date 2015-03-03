class alfresco::addons::rm inherits alfresco::addons {

	$filename_rm = "alfresco-rm-2.3.c.zip"
	$url_rm = "https://process.alfresco.com/ccdl/?file=release/community/5.0.c-build-00145/${filename_rm}"


  exec { "retrieve-rm":
    user => 'tomcat7',
		timeout => 0,
    creates => "${download_path}/${filename_rm}",
    command => "wget ${url_jsconsole} -O ${download_path}/${filename_rm}",
    path => "/usr/bin",
    require => File["${download_path}/rm"],
  }

  exec { "unpack-rm":
    user => 'tomcat7',
    creates => "${download_path}/rm/README.txt",
    cwd => "${download_path}/rm",
    command => "unzip -o ${download_path}/${filename_rm}",
    require => [
      File["${download_path}/rm"],
      Exec["retrieve-rm"],
			Package["unzip"],
    ],
    path => "/usr/bin",
  }


  file { "${download_path}/rm":
    ensure => directory,
    before => Exec["unpack-rm"],
    owner => 'tomcat7',
  }

  file { "${alfresco_base_dir}/amps/alfresco-rm-server-2.3.c.amp":
    source => "${download_path}/rm/alfresco-rm-server-2.3.c.amp",
    ensure => present,
    require => [
      Exec["unpack-rm"],
    ],
		notify => Exec["apply-addons"],
    owner => 'tomcat7',
  }

  file { "${alfresco_base_dir}/amps_share/alfresco-rm-share-2.3.c.amp":
    source => "${download_path}/rm/alfresco-rm-share-2.3.c.amp",
    ensure => present,
    require => [
      Exec["unpack-rm"],
    ],
		notify => Exec["apply-addons"],
    owner => 'tomcat7',
  }


}

