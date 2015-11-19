class alfresco::addons::reset-password inherits alfresco::addons {

  safe-download { 'addons::reset-password':
    url => "https://github.com/share-extras/reset-password-dialog/releases/download/v2.1.0/reset-password-dialog-2.1.0.jar",
    filename => "reset-password-dialog-2.1.0.jar",
    download_path => "${tomcat_home}/shared/lib",
  }

}
