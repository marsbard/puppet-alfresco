class alfresco::install::postgresql inherits alfresco {
    if $db_host == 'localhost' and $db_type == 'postgresql'  {
        
    class { 'postgresql::globals':
       encoding => 'UTF-8',
       locale   => 'en_US.UTF-8',
       manage_package_repo => true,
       version             => '9.3',
    }->
    class { '::postgresql::server': }
       postgresql::server::role { "${db_user}":
          password_hash => postgresql_password("${db_user}", "${db_pass}"),
       }
       postgresql::server::database_grant { "${db_name}":
          privilege => 'ALL',
          db        => "${db_name}",
          role      => "${db_user}",
       }
       postgresql::server::db { "${db_name}":
          user     => "${db_user}",
          password => postgresql_password("${db_name}","${db_pass}"),
       }
    }

    if $db_type == 'postgresql' {

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
}
