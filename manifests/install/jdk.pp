class alfresco::install::jdk inherits alfresco {

#  class { 'jdk_oracle':
#    version => $install_java_version,
#    before => Service['alfresco-start'],
#    default_java => true,
#  }

  class { 'java':
    version => $install_java_version,
  }

}
