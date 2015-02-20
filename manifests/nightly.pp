class alfresco::nightly inherits alfresco{

  case $alfresco_version {
    'NIGHTLY': {

        exec { "retrieve-nightly":
          user => 'tomcat7',
		      timeout => 0,
          command => "wget ${urls::nightly}",
          cwd => $download_path,
          require => [
            File[$download_path],
          ],
          path => '/usr/bin',
          creates => "${download_path}/${urls::nightly_filename}",
        }

        exec { 'unpack-nightly':
          user => 'tomcat7',
          require => [
            Exec['retrieve-nightly'], 
            #File[$alfresco_base_dir],
          ],
          command => "unzip ${download_path}/${urls::nightly_filename}",
          path => '/usr/bin',
          creates => "${download_path}/${urls::nightly_name}/README.txt",
          cwd => $download_path,
        }

        exec { 'copy-nightly':
          user => 'tomcat7',
          require => [
            File[$alfresco_base_dir],
            Exec['unpack-nightly'],
          ],
          command => "/bin/cp -r ${download_path}/${urls::nightly_name}/* $alfresco_base_dir",
          creates => "${alfresco_base_dir}/README.txt",
        }

        exec { 'rename-web-server-folder':
          user => 'tomcat7',
          require =>  Exec['copy-nightly'], 
          # "mv -n" to ensure that this isn't getting applied out of order
          command => "mv -n ${alfresco_base_dir}/web-server ${alfresco_base_dir}/tomcat",
          path => '/bin',
          before => Exec['unpack-tomcat7'],
          creates => "${alfresco_base_dir}/tomcat/webapps",
        }

        exec { "${tomcat_home}/webapps/alfresco.war":
          user => 'tomcat7',
          command => "touch /tmp/fake.get.alfresco.war",
	        path => '/bin:/usr/bin',
          creates => "/tmp/fake.get.alfresco.war",
        }

        exec { "${tomcat_home}/webapps/share.war":
          user => 'tomcat7',
          command => "touch /tmp/fake.get.share.war",
	        path => '/bin:/usr/bin',
          creates => "/tmp/fake.get.share.war",
        }
    }
  }

}
