class alfresco::backup (
  $duplicity_password = '',
  $fulldays = '30D',
  $backup_policies_enabled = 'true',
  $clean_time = '12M',
  $maxfull = 6,
  $volume_size = 25,
  $duplicity_log_verbosity = 4,
  $backuptype = 'local',   # s3, ftp, scp, local
  $local_backup_folder = '/mnt/backup',
  $aws_access_key_id = '',
  $aws_secret_access_key = '',
  $s3filesyslocation = 'http://your-bucket-name',
  $ftp_server = '',
  $ftp_user = '',
  $ftp_password = '',
  $ftp_folder = '',
  $ftp_port = 21,
  $ftps_enable = 'false',
  $scp_server = '',
  $scp_user = '',
  $scp_folder = '',
) inherits alfresco {
  
  $pkgs = [ 'duplicity', 'gzip' ]

  # TODO is there a safer way to make a password without using generate()
# yes - pass it in from above - but leave the example here for now
  #$duplicity_password = generate("tr -cd '[:alnum:]' < /dev/urandom | fold -w30 | head -n1")

  if $alfresco_version =~ /^v4/ {
    $indextype = 'solr',
  } else {
    $indextype = 'solr4'
  }

  package { $pkgs:
    ensure => present,
  }

  vcsrepo { "${alfresco_base_dir}/bart":
    ensure   => present,
    provider => git,
    source   => "http://github.com/toniblyx/alfresco-backup-and-recovery-tool.git",
    require => File["${alfresco_base_dir}/bart"],
  }

  file { "${alfresco_base_dir}/bart":
    ensure => directory,
    require => File[$alfresco_base_dir],
  }

}
