class alfresco::addons::monitorix inherits alfresco::addons {
  if ( $osfamily == "Debian" ) {
    # deb http://apt.izzysoft.de/ubuntu generic universe

    # this ends up adding 'trusty' to the source for some reason
    #apt::source { 'izzysoft':
    #  location => 'http://apt.izzysoft.de/ubuntu',
    #  repos => 'generic universe',
    #  before => Package['monitorix'],
    #}

		file { '/tmp':
		  ensure => directory,
		} ->
    alfresco::safe_download { 'izzysoft gpg key':
      url => 'http://apt.izzysoft.de/izzysoft.asc',
      filename => 'izzysoft.asc',
      download_path => '/tmp',
    } -> 
    exec { '/usr/bin/apt-key add /tmp/izzysoft.asc':
    } ->
    file { '/etc/apt/sources.list.d/izzysoft.list':
      ensure => present,
      content => "deb http://apt.izzysoft.de/ubuntu generic universe",
    } -> 
    exec { '/usr/bin/apt-get update': 
      before => Package['monitorix'],
    }

  }

  if ( $osfamily == "RedHat" ) {
    yumrepo { 'izzysoft':
      baseurl => 'http://apt.izzysoft.de/redhat',
      gpgkey => 'http://apt.izzysoft.de/izzysoft.asc',    
      before => Package['monitorix'],
    }
  }

  package { 'monitorix':
    ensure => installed,
  } -> 
  file { '/etc/monitorix/monitorix.conf':
    content => template('alfresco/monitorix.conf.erb'),
    ensure => present,
  } ~>
  service {'monitorix':
    ensure => running,
  }

}
