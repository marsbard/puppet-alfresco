class alfresco::install::jdk inherits alfresco {

  class { 'jdk_oracle':
    version => $java_version,
  }

}
