class alfresco::addons::filebrowser inherits alfresco::addons {

	vcsrepo { "/var/www/${domain_name}":
		ensure   => present,
		provider => git,
		source   => 'https://github.com/joni2back/angular-filemanager.git',
	}

}
