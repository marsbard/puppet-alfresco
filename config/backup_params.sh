
IDX=0
params[$IDX]="backuptype"
descr[$IDX]="Type of backup. Choose one of the options and then configure the appropriate settings." 
default[$IDX]="local"
required[$IDX]=1
choices[$IDX]="s3|ftp|scp|local"


IDX=$(( $IDX + 1 ))
params[$IDX]="backup_at_hour"
descr[$IDX]="Hour of the day (0-24) at which time we should run the backup."
default[$IDX]=2
required[$IDX]=1

IDX=$(( $IDX + 1 ))
params[$IDX]="backup_at_min"
descr[$IDX]="Minute of the hour (0-59) at which time we should run the backup. If you leave it blank a random minute is selected. TODO: CHECKTHIS"
default[$IDX]=""
required[$IDX]=1

IDX=$(( $IDX + 1 ))
params[$IDX]="duplicity_password"
descr[$IDX]="Password with which to protect the duplicity backup files."
default[$IDX]=""
required[$IDX]=0

IDX=$(( $IDX + 1 ))
params[$IDX]="local_backup_folder"
descr[$IDX]="Local backup folder. If you are using this you have probably mounted a remote backup folder locally."
default[$IDX]="/mnt/backup"
required[$IDX]=1
onlyif[$IDX]="backuptype=local"

IDX=$(( $IDX + 1 ))
params[$IDX]="fulldays"
descr[$IDX]="Number of days between full backups. (If no backup is found then a full backup is done)."
default[$IDX]="30D"
required[$IDX]=1

IDX=$(( $IDX + 1 ))
params[$IDX]="backup_policies_enabled"
descr[$IDX]="Backup policies to apply all backups collections (retention and cleanup)"
default[$IDX]="true"
required[$IDX]=1
choices[$IDX]="true|false"

IDX=$(( $IDX + 1 ))
params[$IDX]="clean_time"
descr[$IDX]="Remove backups older than this (or backup retention period) TODO: Clarify this description"
default[$IDX]="12M"
required[$IDX]=1

IDX=$(( $IDX + 1 ))
params[$IDX]="maxfull"
descr[$IDX]="After MAXFULL counter, all incrementals will be deleted and all full will be kept until CLEAN_TIME applies"
default[$IDX]="6"
required[$IDX]=1

IDX=$(( $IDX + 1 ))
params[$IDX]="volume_size"
descr[$IDX]="If you want to keep full backups of last 12 months but only with incremental\nin last 6 months you must set CLEAN_TIME=12M and MAXFULL=6.\nVolume size in MB, default is 25MB per backup volume, consider reduce or increase it\nif you are doing tape backup (if a backup takes up 60MB you will get 3 volumes, 25+25+10)"
default[$IDX]="25"
required[$IDX]=1

IDX=$(( $IDX + 1 ))
params[$IDX]="duplicity_log_verbosity"
descr[$IDX]="Duplicity log verbosity 0 Error, 2 Warning, 4 Notice, 8 Info, 9 Debug (noisiest)\n0 recommended for production"
default[$IDX]="4"
required[$IDX]=1

IDX=$(( $IDX + 1 ))
params[$IDX]="aws_access_key_id"
descr[$IDX]="Amazon Web Services - Access Key ID"
default[$IDX]=""
required[$IDX]=1
onlyif[$IDX]="backuptype=s3"

IDX=$(( $IDX + 1 ))
params[$IDX]="aws_secret_access_key"
descr[$IDX]="Amazon Web Services - Secret Access Key"
default[$IDX]=""
required[$IDX]=1
onlyif[$IDX]="backuptype=s3"

IDX=$(( $IDX + 1 ))
params[$IDX]="s3filesyslocation"
descr[$IDX]="S3 File system location - upper case bucket name is not allowed"
default[$IDX]="s3+http://your-bucket-name"
required[$IDX]=1
onlyif[$IDX]="backuptype=s3"

IDX=$(( $IDX + 1 ))
params[$IDX]="ftp_server"
descr[$IDX]="Address of FTP server"
default[$IDX]=""
required[$IDX]=1
onlyif[$IDX]="backuptype=ftp"

IDX=$(( $IDX + 1 ))
params[$IDX]="ftp_user"
descr[$IDX]="User to log in as on remote FTP server"
default[$IDX]=""
required[$IDX]=1
onlyif[$IDX]="backuptype=ftp"

IDX=$(( $IDX + 1 ))
params[$IDX]="ftp_password"
descr[$IDX]="Password of FTP user"
default[$IDX]=""
required[$IDX]=1
onlyif[$IDX]="backuptype=ftp"

IDX=$(( $IDX + 1 ))
params[$IDX]="ftp_port"
descr[$IDX]="Port of FTP server"
default[$IDX]="21"
required[$IDX]=0
onlyif[$IDX]="backuptype=ftp"

IDX=$(( $IDX + 1 ))
params[$IDX]="ftps_enable"
descr[$IDX]="Should we use FTPS to communicate with the FTP server?"
default[$IDX]="false"
required[$IDX]=0
onlyif[$IDX]="backuptype=ftp"
choices[$IDX]="true|false"

IDX=$(( $IDX + 1 ))
params[$IDX]="scp_server"
descr[$IDX]="Address of machine which is the SCP target"
default[$IDX]=""
required[$IDX]=1
onlyif[$IDX]="backuptype=scp"

IDX=$(( $IDX + 1 ))
params[$IDX]="scp_user"
descr[$IDX]="User to connect as. Your public key should be in the ~/.ssh/authorized_keys file on the server."
default[$IDX]=""
required[$IDX]=1
onlyif[$IDX]="backuptype=scp"

IDX=$(( $IDX + 1 ))
params[$IDX]="scp_folder"
descr[$IDX]="Path on remote server to store the backups at."
default[$IDX]=""
required[$IDX]=1
onlyif[$IDX]="backuptype=scp"

