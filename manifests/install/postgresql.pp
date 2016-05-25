class alfresco::install::postgresql inherits alfresco {
    if $db_host == 'localhost'  {
    class { '::postgresql::server':
      postgres_password    => $db_root_password,
      }
    }
}
