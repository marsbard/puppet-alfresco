class alfresco::addons::monitorix inherits alfresco::addons {
  if ( $osfamily == "Debian" ) {
    # deb http://apt.izzysoft.de/ubuntu generic universe

    # this ends up adding 'trusty' to the source for some reason
    #apt::source { 'izzysoft':
    #  location => 'http://apt.izzysoft.de/ubuntu',
    #  repos => 'generic universe',
    #  before => Package['monitorix'],
    #}


    # http://serverfault.com/a/516919/319703
    exec { 'check_presence_izzy_key':
      command => '/bin/true',
      unless => '/usr/bin/test -e /tmp/izzysoft.asc',
    }

    file { '/tmp':
      ensure => directory,
    } ->
    alfresco::safe_download { 'izzysoft gpg key':
      url => 'http://apt.izzysoft.de/izzysoft.asc',
      filename => 'izzysoft.asc',
      download_path => '/tmp',
      require => Exec['check_presence_izzy_key'],
    } -> 
    exec { '/usr/bin/apt-key add /tmp/izzysoft.asc':
      unless => '/usr/bin/test -e /etc/apt/sources.list.d/izzysoft.list',
    } ->
    file { '/etc/apt/sources.list.d/izzysoft.list':
      ensure => present,
      content => "deb http://apt.izzysoft.de/ubuntu generic universe",
    } -> 
    exec { '/usr/bin/apt-get update': 
      before => Package['monitorix'],
			creates => '/opt/alfresco/.flag-updated-apt-after-monitorix',
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
