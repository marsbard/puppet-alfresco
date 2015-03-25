class alfresco::addons::reset-password inherits alfresco::addons {

  exec { 'retrieve-reset-password':
    command => 'wget https://github.com/share-extras/reset-password-dialog/releases/download/v2.1.0/reset-password-dialog-2.1.0.jar',
    cwd => "${tomcat_home}/shared/lib",
    path => '/usr/bin',
    creates => "${tomcat_home}/shared/lib/reset-password-dialog-2.1.0.jar",
  }

}
