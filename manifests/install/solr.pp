class alfresco::install::solr inherits alfresco {

  case ($alfresco_version) {
    '4.2.f': {

      safe_download { 'solr':
        url => "${urls::solr_dl}",
        filename => 'solr.zip',
        download_path => $download_path,
      }

      exec { "unpack-solr":
        user => 'tomcat',
        command => "unzip ${download_path}/solr.zip -d solr/",
        cwd => $alfresco_base_dir,
        path => '/usr/bin',
        creates => "${alfresco_base_dir}/solr/solr.xml",
        require => [
          Safe-download["solr"],
        ],
      }

      file { "${alfresco_base_dir}/solr/alf_data":
        ensure => absent,
        force => true,
        require => Exec["unpack-alfresco-ce"],
        before => Service["alfresco-start"],
        owner => 'tomcat',
      }


      file { "${alfresco_base_dir}/solr/workspace-SpacesStore/conf/solrcore.properties":
        require => Exec['unpack-solr'],
        content => template('alfresco/solrcore-workspace.properties.erb'),
        ensure => present,
        owner => 'tomcat',
      }


      file { "${alfresco_base_dir}/solr/archive-SpacesStore/conf/solrcore.properties":
        require => Exec['unpack-solr'],
        content => template('alfresco/solrcore-archive.properties.erb'),
        ensure => present,
        owner => 'tomcat',
      }

      file { "${tomcat_home}/conf/Catalina/localhost/solr.xml":
        content => template('alfresco/solr.xml.erb'),
        ensure => present,
        owner => 'tomcat',
      }



      file { "${alfresco_base_dir}/solr/archive-SpacesStore/conf/solrconfig.xml":
        require => Exec['unpack-solr'],
        source => 'puppet:///modules/alfresco/solrconfig.xml',
        ensure => 'present',
        owner => 'tomcat',
      }

      file { "${alfresco_base_dir}/solr/workspace-SpacesStore/conf/solrconfig.xml":
        require => Exec['unpack-solr'],
        source => 'puppet:///modules/alfresco/solrconfig.xml',
        ensure => 'present',
        owner => 'tomcat',
      }




    }


    '5.0.c', '5.0.x', 'NIGHTLY': {

      safe_download { 'solr-war':
        url => "${urls::solr_war_dl}",
        filename => "solr4.war",
        download_path => "${tomcat_home}/webapps",
      }

      file { "${alfresco_base_dir}/solr4":
        ensure => directory,
        require => File[$alfresco_base_dir],
        owner => 'tomcat',
      }
      file { "${alfresco_base_dir}/alf_data/solr4":
        ensure => directory,
        require => File[$alfresco_base_dir],
        owner => 'tomcat',
      }

      safe_download { 'solr-cfg':
        url => "${urls::solr_cfg_dl}",
        filename => 'solrconfig.zip',
        download_path => $download_path,
      }

      exec { "unpack-solr-cfg":
        user => 'tomcat',
        command => "unzip -o ${download_path}/solrconfig.zip",
        cwd => "${alfresco_base_dir}/solr4",
        path => '/usr/bin',
        creates => "${alfresco_base_dir}/solr4/context.xml",
        require => Safe-download['solr-cfg'],
        notify => Service['alfresco-start'],
      }

      file { "${alfresco_base_dir}/solr4/archive-SpacesStore/conf/solrconfig.xml":
        require => Exec['unpack-solr-cfg'],
        source => 'puppet:///modules/alfresco/solr4config.xml',
        ensure => 'present',
        owner => 'tomcat',
      }

      file { "${alfresco_base_dir}/solr4/workspace-SpacesStore/conf/solrconfig.xml":
        require => Exec['unpack-solr-cfg'],
        source => 'puppet:///modules/alfresco/solr4config.xml',
        ensure => 'present',
        owner => 'tomcat',
      }

      file { "${tomcat_home}/conf/Catalina/localhost/solr4.xml":
        content => template('alfresco/solr4.xml.erb'),
        ensure => present,
        require => Exec['unpack-solr-cfg'],
        owner => 'tomcat',
      }

      file { "${alfresco_base_dir}/solr4/workspace-SpacesStore/conf/solrcore.properties":
        ensure => present,
        content => template('alfresco/solr4core-workspace.properties.erb'),
        require => Exec['unpack-solr-cfg'],
        before => Service['alfresco-start'],
        owner => 'tomcat',
      }

      file { "${alfresco_base_dir}/solr4/archive-SpacesStore/conf/solrcore.properties":
        ensure => present,
        content => template('alfresco/solr4core-archive.properties.erb'),
        require => Exec['unpack-solr-cfg'],
        before => Service['alfresco-start'],
        owner => 'tomcat',
      }

    }



  }
}
