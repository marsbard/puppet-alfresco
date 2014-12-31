class alfresco::addons inherits alfresco {

	include alfresco::addons::jsconsole



	exec { "apply-addons":
                require => [
                        File["${alfresco_base_dir}/bin/apply_amps.sh"],
			File["${alfresco_base_dir}/bin/alfresco-mmt.jar"],
                ],
                path => "/bin:/usr/bin",
                command => "${alfresco_base_dir}/bin/apply_amps.sh",
                notify => Exec["fix-war-permissions"],
        }

        file { "${alfresco_base_dir}/bin/apply_amps.sh":
                ensure => present,
                mode => "0755",
                content => template("alfresco/apply_amps.sh.erb"),
                require => File["${alfresco_base_dir}/bin"],
        }

	file { "${alfresco_base_dir}/bin/clean_tomcat.sh":
		ensure => present,
		mode => '0755',
		source => "${download_path}/alfresco/bin/clean_tomcat.sh",
                require => File["${alfresco_base_dir}/bin"],
	}

	file { "${alfresco_base_dir}/bin/alfresco-mmt.jar":
		ensure => present,
		mode => '0755',
		source => "${download_path}/alfresco/bin/alfresco-mmt.jar",
                require => File["${alfresco_base_dir}/bin"],
	}

        exec { "fix-war-permissions":
                path => "/bin",
                command => "chown tomcat7 ${tomcat_home}/webapps/*.war; chmod a+r ${tomcat_home}/webapps/*.war",
        }

}
