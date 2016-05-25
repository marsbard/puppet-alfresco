class alfresco::install::postgresql inherits alfresco {
    if $db_host == 'localhost' and $db_type == 'postgresql'  {
    class { '::postgresql::server': }
       postgresql::server::db { "$alfresco_db_name":
          user     => "${alfresco_db_user}",
          password => postgresql_password("$alfresco_db_name","${alfresco_db_pass}"),
       }
    }
    class { '::postgresql::lib::java':
       package_ensure => 'present',
    }
    alfresco::safe_download { 'postgresql-connector':
       url => "${alfresco::urls::postgresql_connector_url}",
       filename => "${alfresco::urls::postgresql_connector_file}",
       download_path => $download_path,
    }
    exec { "unpack-postgresql-connector":
       user => 'tomcat',
       command => "echo ${alfresco::urls::postgresql_connector_file}",
       cwd => $download_path,
       path => "/bin",
       require => Alfresco::Safe_download["postgresql-connector"],
       creates => "${download_path}/${alfresco::urls::postgresql_connector_name}",
    }
    exec { "copy-postgresql-connector":
       user => 'tomcat',
       command => "cp ${download_path}/${alfresco::urls::postgresql_connector_name}.jar  ${tomcat_home}/shared/lib/",
       path => "/bin:/usr/bin",
       require => [
          Exec["unpack-postgresql-connector"],
          File["${tomcat_home}/shared/lib"],
       ],
       creates => "${tomcat_home}/shared/lib/${alfresco::urls::postgresql_connector_name}.jar",
    }
}
