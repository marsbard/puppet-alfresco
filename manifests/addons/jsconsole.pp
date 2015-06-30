class alfresco::addons::jsconsole inherits alfresco::addons {

	$filename_jsconsole = "javascript-console-0.5.1.zip"
	$url_jsconsole = "https://share-extras.googlecode.com/files/${filename_jsconsole}"

	safe-download {'jsconsole':
		url => $url_jsconsole,
		filename => $filename_jsconsole,
		download_path => $download_path,
	}

  exec { "unpack-jsconsole":
    user => 'tomcat',
    creates => "${download_path}/jsconsole/README.txt",
    cwd => "${download_path}/jsconsole",
    command => "unzip -o ${download_path}/${filename_jsconsole}",
    require => [
      File["${download_path}/jsconsole"],
      Safe-download["jsconsole"],
			Package["unzip"],
    ],
    path => "/usr/bin",
  }


  file { "${download_path}/jsconsole":
    ensure => directory,
    before => Exec["unpack-jsconsole"],
    owner => 'tomcat',
  }

  file { "${alfresco_base_dir}/amps/javascript-console-repo-0.5.1.amp":
    source => "${download_path}/jsconsole/4.0.x/javascript-console-repo-0.5.1.amp",
    ensure => present,
    require => [
      Exec["unpack-jsconsole"],
    ],
		notify => Exec["apply-addons"],
    owner => 'tomcat',
  }

  file { "${alfresco_base_dir}/amps_share/javascript-console-share-0.5.1.amp":
    source => "${download_path}/jsconsole/4.0.x/javascript-console-share-0.5.1.amp",
    ensure => present,
    require => [
      Exec["unpack-jsconsole"],
    ],
		notify => Exec["apply-addons"],
    owner => 'tomcat',
  }


}

