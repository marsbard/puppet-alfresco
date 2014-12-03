class alfresco::addons::jsconsole inherits alfresco::addons {

	$filename_jsconsole = "javascript-console-0.5.1.zip"
	$url_jsconsole = "https://share-extras.googlecode.com/files/${filename_jsconsole}"


        exec { "retrieve-jsconsole":
                creates => "${downloads_path}/${filename_jsconsole}",
                command => "wget ${url_jsconsole} -O ${downloads_path}/${filename_jsconsole}",
                path => "/usr/bin",
                require => File["/opt/downloads/jsconsole"],
        }

        exec { "unpack-jsconsole":
                creates => "/opt/downloads/jsconsole/README.txt",
                cwd => "/opt/downloads/jsconsole",
                command => "unzip -o ${downloads_path}/${filename_jsconsole}",
                require => [
                        File["/opt/downloads/jsconsole"],
                        Exec["retrieve-jsconsole"],
                ],
                path => "/usr/bin",
        }


        file { "/opt/downloads/jsconsole":
                ensure => directory,
                before => Exec["unpack-jsconsole"],
        }

        file { "${alfresco_base_dir}/amps/javascript-console-repo-0.5.1.amp":
                source => "/opt/downloads/jsconsole/4.0.x/javascript-console-repo-0.5.1.amp",
                ensure => present,
                require => [
                        Exec["unpack-jsconsole"],
                ],
		notify => Exec["apply-addons"],
        }
        file { "${alfresco_base_dir}/amps_share/javascript-console-share-0.5.1.amp":
                source => "/opt/downloads/jsconsole/4.0.x/javascript-console-share-0.5.1.amp",
                ensure => present,
                require => [
                        Exec["unpack-jsconsole"],
                ],
		notify => Exec["apply-addons"],
        }


}

