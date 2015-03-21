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
  }

}
