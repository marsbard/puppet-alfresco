OUTFILE='do_backup.pp'


function write_output {

  backup_at_hour=`get_param backup_at_hour`
  backup_at_min=`get_param backup_at_min`
  duplicity_password=`get_param duplicity_password`
  fulldays=`get_param fulldays`
  backup_policies_enabled=`get_param backup_policies_enabled`
  clean_time=`get_param clean_time`
  maxfull=`get_param maxfull`
  volume_size=`get_param volume_size`
  duplicity_log_verbosity=`get_param duplicity_log_verbosity`
  backuptype=`get_param backuptype`
  local_backup_folder=`get_param local_backup_folder`
  aws_access_key_id=`get_param aws_access_key_id`
  aws_secret_access_key=`get_param aws_secret_access_key`
  s3filesyslocation=`get_param s3filesyslocation`
  ftp_server=`get_param ftp_server`
  ftp_user=`get_param ftp_user`
  ftp_password=`get_param ftp_password`
  ftp_folder=`get_param ftp_folder`
  ftp_port=`get_param ftp_port`
  ftps_enable=`get_param ftps_enable`
  scp_server=`get_param scp_server`
  scp_user=`get_param scp_user`
  scp_folder=`get_param scp_folder`

	echo -e "${GREEN}Writing puppet file ${BLUE}${OUTFILE}${WHITE}"
	cat > ${OUTFILE} <<EOF
class { 'alfresco::backup':
  backup_at_hour => '${backup_at_hour}',
  backup_at_min => '${backup_at_min}',
  duplicity_password => '${duplicity_password}',
  fulldays => '${fulldays}',
  backup_policies_enabled => '${backup_policies_enabled}',
  clean_time => '${clean_time}',
  maxfull => '${maxfull}',
  volume_size => '${volume_size}',
  duplicity_log_verbosity => '${duplicity_log_verbosity}',
  backuptype => '${backuptype}',
  local_backup_folder => '${local_backup_folder}',
  aws_access_key_id => '${aws_access_key_id}',
  aws_secret_access_key => '${aws_secret_access_key}',
  s3filesyslocation => '${s3filesyslocation}',
  ftp_server => '${ftp_server}',
  ftp_user => '${ftp_user}',
  ftp_password => '${ftp_password}',
  ftp_folder => '${ftp_folder}',
  ftp_port => '${ftp_port}',
  ftps_enable => '${ftps_enable}',
  scp_server => '${scp_server}',
  scp_user => '${scp_user}',
  scp_folder => '${scp_folder}',
}
EOF
	sleep 1
}


write_output

