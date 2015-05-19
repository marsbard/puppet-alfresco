class alfresco::addons::webscripts inherits alfresco::addons {

	$createsite_files = [
		'create-site.get.desc.xml',
		'create-site.get.html.ftl',  
		'create-site.get.js',
	]


	file { ["${download_path}/webscripts", 
			"${download_path}/webscripts/alfresco", 
			"${download_path}/webscripts/alfresco/extension", 
			"${download_path}/webscripts/alfresco/extension/templates", 
			"${download_path}/webscripts/alfresco/extension/templates/webscripts", 
			"${download_path}/webscripts/alfresco/extension/templates/webscripts/org", 
			"${download_path}/webscripts/alfresco/extension/templates/webscripts/org/orderofthebee", 
			"${download_path}/webscripts/alfresco/extension/templates/webscripts/org/orderofthebee/create-site", 
	] :
		ensure => directory,
	}

	file { "${alfresco_base_dir}/bin/jar-to-amp.sh":
		mode => '0775',
		source => "puppet:///modules/alfresco/jar-to-amp.sh",
		ensure => present,
	}

	define webscript-copy (
		$file=$title,
		$qual
	) {
		file {"${alfresco::download_path}/webscripts/alfresco/extension/templates/webscripts/${qual}/${file}":
			ensure => file,
			owner => tomcat,
			group => tomcat,
			mode => '0644',
			source => "puppet:///modules/alfresco/webscripts/create-site/${file}",
		}
	}

	webscript-copy { $createsite_files:
		qual => "org/orderofthebee/create-site",
	}


	exec { "pack-createsite-jar":
		cwd => "${download_path}/webscripts",
		command => "zip -r create-site.jar alfresco/extension/templates/webscripts/org/orderofthebee/create-site",
		path => "/usr/bin",
		creates => "${download_path}/webscripts/create-site.jar",
		require => Webscript-copy[$createsite_files],
	}

	exec { "jar-to-amp-createsite":
		command => "${alfresco_base_dir}/bin/jar-to-amp.sh '${download_path}/webscript/create-site.jar' org.orderofthebee.webscripts.create-site create-site 0.1 '${alfresco_base_dir}/amps/create-site-0.1.amp' 'script to create a site'",
		creates => "${alfresco_base_dir}/amps/create-site-0.1.amp",
		require => Exec['pack-createsite-jar'],
		before => Exec['apply-addons'],
	}

}
