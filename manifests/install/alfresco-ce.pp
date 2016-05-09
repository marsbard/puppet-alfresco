class alfresco::install::alfresco-ce inherits alfresco::install {

  case ($alfresco_version){
      '4.2.f', '4.2.x': {

        safe_download { 'alfresco-ce':
          url => "${alfresco::urls::alfresco_ce_url}",
          filename => "${alfresco::urls::alfresco_ce_filename}",
          download_path => $download_path,
        }

        file { "${download_path}/alfresco":
          ensure => directory,
          owner => 'tomcat',
        }

        exec { "unpack-alfresco-ce":
          user => 'tomcat',
          command => "unzip -o ${download_path}/${alfresco::urls::alfresco_ce_filename} -d ${download_path}/alfresco",
          path => "/usr/bin",
          require => [ 
            Safe_download['alfresco-ce'],
            Exec["copy tomcat to ${tomcat_home}"], 
            Package["unzip"], 
            File["${download_path}/alfresco"],
          ],
          creates => "${download_path}/alfresco/README.txt",
        }


        # the war files
        exec { "${tomcat_home}/webapps/alfresco.war":
          user => 'tomcat',
          command => "cp ${alfresco_war_loc}/alfresco.war ${tomcat_home}/webapps/alfresco.war",
          require => Exec["unpack-alfresco-ce"],
          creates => "${tomcat_home}/webapps/alfresco.war",
          path => '/bin:/usr/bin',
          notify => Service['alfresco-start']
        }
        exec { "${tomcat_home}/webapps/share.war":
          user => 'tomcat',
          command => "cp ${alfresco_war_loc}/share.war ${tomcat_home}/webapps/share.war",
          creates => "${tomcat_home}/webapps/share.war",
          path => '/bin:/usr/bin',
          notify => Service['alfresco-start'],
          require => [
            File["${alfresco_base_dir}/amps"],
            Exec["unpack-alfresco-ce"],
          ]
        }
        safe_download { 'alfresco.war':
          url => "${alfresco::urls::alfresco_war_42x}",
          filename => "alfresco.war",
          download_path => "${tomcat_home}/webapps/",
        }
        safe_download { 'share.war':
          url => "${alfresco::urls::share_war_42x}",
          filename => "share.war",
          download_path => "${tomcat_home}/webapps/",
        }
        file { "${tomcat_home}/webapps":
          ensure => directory,
          require => File["${tomcat_home}"],
          owner => 'tomcat',
        }

        safe_download { 'spp':
          url => "${alfresco::urls::spp_v4}",
          filename => "${alfresco::urls::spp_v4_zipname}",
          download_path => $download_path,
        }

        exec { 'unpack-spp':
          user => 'tomcat',
          command => "/usr/bin/unzip ${download_path}/${alfresco::urls::spp_v4_zipname}",
          cwd => "${alfresco_base_dir}/amps",
          creates => "${alfresco_base_dir}/amps/${alfresco::urls::spp_v4_name}",
          require => [ File[$download_path], Safe_download['spp'], ], 
        }


        exec { "unpack-alfresco-war": 
          user => 'tomcat',
              require => [
            Safe_download["alfresco.war"],
            Exec['apply-addons'],
          ],
          before => Service['alfresco-start'],
          path => "/bin:/usr/bin",
          command => "unzip -o -d ${tomcat_home}/webapps/alfresco ${tomcat_home}/webapps/alfresco.war && chown -R tomcat ${tomcat_home}/webapps/alfresco", 
          creates => "${tomcat_home}/webapps/alfresco/",
        }

        exec { "unpack-share-war": 
          user => 'tomcat',
          require => [
            Safe_download["share.war"],
            Exec['apply-addons'],
          ],
          before => Service['alfresco-start'],
          path => "/bin:/usr/bin",
          command => "unzip -o -d ${tomcat_home}/webapps/share ${tomcat_home}/webapps/share.war && chown -R tomcat ${tomcat_home}/webapps/share", 
          creates => "${tomcat_home}/webapps/share/",
        }



      }
      '5.0.c', '5.0.x': {

        safe_download { 'alfresco.war':
          url => "${alfresco::urls::alfresco_war_50x}",
          filename => "alfresco.war",
          download_path => "${tomcat_home}/webapps/",
        }
        safe_download { 'share.war':
          url => "${alfresco::urls::share_war_50x}",
          filename => "share.war",
          download_path => "${tomcat_home}/webapps/",
        }

        file { "${tomcat_home}/webapps":
          ensure => directory,
          require => File["${tomcat_home}"],
          owner => 'tomcat',
        }
        
        safe_download { 'spp-amp':
          url => "${alfresco::urls::spp_amp_v5}",
          filename => "${alfresco::urls::spp_amp_v5_name}",
          download_path => "${alfresco_base_dir}/amps",
        }


        exec { "unpack-alfresco-war": 
          user => 'tomcat',
              require => [
            Safe_download["alfresco.war"],
            Exec['apply-addons'],
          ],
          before => Service['alfresco-start'],
          path => "/bin:/usr/bin",
          command => "unzip -o -d ${tomcat_home}/webapps/alfresco ${tomcat_home}/webapps/alfresco.war && chown -R tomcat ${tomcat_home}/webapps/alfresco", 
          creates => "${tomcat_home}/webapps/alfresco/",
        }

        exec { "unpack-share-war": 
          user => 'tomcat',
          require => [
            Safe_download["share.war"],
            Exec['apply-addons'],
          ],
          before => Service['alfresco-start'],
          path => "/bin:/usr/bin",
          command => "unzip -o -d ${tomcat_home}/webapps/share ${tomcat_home}/webapps/share.war && chown -R tomcat ${tomcat_home}/webapps/share", 
          creates => "${tomcat_home}/webapps/share/",
        }

      }
      'NIGHTLY': {

          # moved to nightly.pp

      }





  }

}
