class alfresco::addons::ootbfrontpage inherits alfresco::addons {

  vcsrepo { "/var/www/${domain_name}":
    ensure   => present,
    provider => git,
    source   => 'https://github.com/digcat/honeycomb-frontpage.git',
  }

}
