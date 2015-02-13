class alfresco::addons::jsconsole inherits alfresco::addons {

	$filename_jsconsole = "javascript-console-0.5.1.zip"
	$url_jsconsole = "https://share-extras.googlecode.com/files/${filename_jsconsole}"


  exec { "retrieve-jsconsole":
    user => 'tomcat7',
		timeout => 0,
    creates => "${downloads_path}/${filename_jsconsole}",
    command => "wget ${url_jsconsole} -O ${downloads_path}/${filename_jsconsole}",
    path => "/usr/bin",
    require => File["${download_path}/jsconsole"],
  }

  exec { "unpack-jsconsole":
    user => 'tomcat7',
    creates => "${download_path}/jsconsole/README.txt",
    cwd => "${download_path}/jsconsole",
    command => "unzip -o ${downloads_path}/${filename_jsconsole}",
    require => [
      File["${download_path}/jsconsole"],
      Exec["retrieve-jsconsole"],
			Package["unzip"],
    ],
    path => "/usr/bin",
  }


  file { "${download_path}/jsconsole":
    ensure => directory,
    before => Exec["unpack-jsconsole"],
    owner => 'tomcat7',
  }

  file { "${alfresco_base_dir}/amps/javascript-console-repo-0.5.1.amp":
    source => "${download_path}/jsconsole/4.0.x/javascript-console-repo-0.5.1.amp",
    ensure => present,
    require => [
      Exec["unpack-jsconsole"],
    ],
		notify => Exec["apply-addons"],
    owner => 'tomcat7',
  }

  file { "${alfresco_base_dir}/amps_share/javascript-console-share-0.5.1.amp":
    source => "${download_path}/jsconsole/4.0.x/javascript-console-share-0.5.1.amp",
    ensure => present,
    require => [
      Exec["unpack-jsconsole"],
    ],
		notify => Exec["apply-addons"],
    owner => 'tomcat7',
  }


}

