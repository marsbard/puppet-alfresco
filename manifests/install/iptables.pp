class alfresco::install::iptables inherits alfresco {


  file { "/etc/init.d/iptables":
    source => 'puppet:///modules/alfresco/iptables.sh',
    ensure => present,
    mode => '0755',
    owner => 'tomcat7',
  }

  file { "/etc/rc2.d/S10_iptables":
    ensure => 'link',
    target => '/etc/init.d/iptables',
    require => File['/etc/init.d/iptables'],
  }

  # should probably do this with a service clause but 
  # this script doesn't provide status so only limited use
  # let's restart and hope that if not already running it's not a failure
  exec { '/etc/init.d/iptables restart':
    require => File['/etc/init.d/iptables'], 
  }

}
