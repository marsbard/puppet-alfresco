class alfresco::install::jdk inherits alfresco {

  class { 'jdk-oracle':
    version => $java_version,
  }

}
