class alfresco::install::jdk inherits alfresco {

#  class { 'jdk_oracle':
#    version => $install_java_version,
#    before => Service['alfresco-start'],
#    default_java => true,
#  }

#  class { 'java':
#    version => $install_java_version,
#  }

  case $::osfamily {
    'Debian': {

      if $install_java_version == 8 {
        $jdkpkg = "openjdk-8-jdk"
      } else {
        $jdkpkg = "openjdk-7-jdk"
      }
    }

  
    'RedHat': {
      if $install_java_version == 8 {
        $jdkpkg = "java-1.8.0-openjdk"
      } else {
        $jdkpkg = "java-1.7.0-openjdk"
      }
    }
  }
   
  package { 'jdk':
    name => $jdkpkg,
    ensure => installed,
  } ->
  exec { 'jvm default link':
    command => 'ln -s /usr/lib/jvm/`update-alternatives --list java | cut -f5 -d/` /usr/lib/jvm/jre',
    path => '/bin:/usr/bin',
    creates => '/usr/lib/jvm/jre', 
  }

}
