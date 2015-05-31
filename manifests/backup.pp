class alfresco::backup (
  $alfresco_base_dir,
  $backup_at_hour = 2,
  $backup_at_min = fqdn_rand(59),
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
  $s3filesyslocation = 's3+http://your-bucket-name',
  $ftp_server = '',
  $ftp_user = '',
  $ftp_password = '',
  $ftp_folder = '',
  $ftp_port = 21,
  $ftps_enable = 'false',
  $scp_server = '',
  $scp_user = '',
  $scp_folder = '',
) {
  

  # TODO is there a safer way to make a password without using generate()
# yes - pass it in from above - but leave the example here for now
  #$duplicity_password = generate("tr -cd '[:alnum:]' < /dev/urandom | fold -w30 | head -n1")


  $pkgs = [ 'duplicity', 'gzip', 'lftp' ]
  package { $pkgs:
    ensure => present,
  }

  file { "${alfresco_base_dir}/scripts/alfresco-bart.sh":
    ensure => present,
    content => template('alfresco/alfresco-bart.sh.erb'),
    mode => '0755',
  } ->
  file { "${alfresco_base_dir}/scripts/alfresco-bart.properties":
    ensure => present,
    content => template('alfresco/alfresco-bart.properties.erb'),
  }
  
  cron { alfresco-bart:
    command => "${alfresco_base_dir}/scripts/alfresco-bart.sh backup",
    user => tomcat,
    hour => $backup_at_hour,
    minute => $backup_at_min,
  }
}
