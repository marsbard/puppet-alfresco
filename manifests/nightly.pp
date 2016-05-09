class alfresco::nightly inherits alfresco{

  case $alfresco_version {
    'NIGHTLY': {

        safe_download { 'nightly':
          url => "${urls::nightly}",
          filename => "${urls::nightly_filename}",
          download_path => $download_path,
        }

        exec { 'unpack-nightly':
          user => 'tomcat',
          require => [
            Safe-download['nightly'], 
            #File[$alfresco_base_dir],
          ],
          command => "unzip ${download_path}/${urls::nightly_filename} ${download_path}/${urls::nightly_name}",
          path => '/usr/bin',
          creates => "${download_path}/${urls::nightly_name}/README.txt",
          cwd => $download_path,
        }

        exec { 'copy-nightly':
          user => 'tomcat',
          require => [
            File[$alfresco_base_dir],
            Exec['unpack-nightly'],
          ],
          command => "/bin/cp -r ${download_path}/${urls::nightly_name}/* $alfresco_base_dir",
          creates => "${alfresco_base_dir}/README.txt",
        }

        exec { 'rename-web-server-folder':
          user => 'tomcat',
          require =>  Exec['copy-nightly'], 
          # "mv -n" to ensure that this isn't getting applied out of order
          command => "mv -n ${alfresco_base_dir}/web-server ${alfresco_base_dir}/tomcat",
          path => '/bin',
          before => Exec['unpack-tomcat'],
          creates => "${alfresco_base_dir}/tomcat/webapps",
        }

        exec { "${tomcat_home}/webapps/alfresco.war":
          user => 'tomcat',
          command => "touch /tmp/fake.get.alfresco.war",
          path => '/bin:/usr/bin',
          creates => "/tmp/fake.get.alfresco.war",
        }

        exec { "${tomcat_home}/webapps/share.war":
          user => 'tomcat',
          command => "touch /tmp/fake.get.share.war",
          path => '/bin:/usr/bin',
          creates => "/tmp/fake.get.share.war",
        }
    }
  }

}
