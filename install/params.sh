
IDX=0
params[$IDX]="domain_name"
descr[$IDX]="Domain name at which the installation will be resolved, e.g. test.orderofthebee.org. This domain name should be resolvable to this machine. For testing, 'localhost' might work." 
default[$IDX]=""
required[$IDX]=1


IDX=$(( $IDX + 1 ))
params[$IDX]="initial_admin_pass"
descr[$IDX]="Admin password for very first run of repo. After first run you can change it from inside the app"
default[$IDX]="admin"

IDX=$(( $IDX + 1 ))
params[$IDX]="mail_from_default"
descr[$IDX]="Default mail address to use in the 'From' field of sent mails"
default[$IDX]="admin@localhost"

IDX=$(( $IDX + 1 ))
params[$IDX]="mail_host"
descr[$IDX]="Address of mail server which will accept mails from us. Leave this as 'localhost' and postfix will be installed locally"
default[$IDX]="localhost"

IDX=$(( $IDX + 1 ))
params[$IDX]="mail_port"
descr[$IDX]="Mail server port. Leave at '25' for localhost."
default[$IDX]="25"


IDX=$(( $IDX + 1 ))
params[$IDX]="alfresco_base_dir"
descr[$IDX]="Where alfresco base folder should go, i.e. location of alf_data"
default[$IDX]="/opt/alfresco"


IDX=$(( $IDX + 1 ))
params[$IDX]="tomcat_home"
descr[$IDX]="Where to install tomcat"
default[$IDX]="/opt/alfresco/tomcat"


IDX=$(( $IDX + 1 ))
params[$IDX]="alfresco_version"
descr[$IDX]="Alfresco version to install. Choices '4.2.f', '5.0.x' and 'NIGHTLY' are supported"
default[$IDX]="5.0.x"


IDX=$(( $IDX + 1 ))
params[$IDX]="download_path"
descr[$IDX]="Where to store downloaded files"
default[$IDX]="/opt/downloads"


IDX=$(( $IDX + 1 ))
params[$IDX]="db_root_password"
descr[$IDX]="Password to use for root user when installing Mysql"
default[$IDX]="alfresco"


IDX=$(( $IDX + 1 ))
params[$IDX]="db_user"
descr[$IDX]="Database user"
default[$IDX]="alfresco"


IDX=$(( $IDX + 1 ))
params[$IDX]="db_pass"
descr[$IDX]="Database password"
default[$IDX]="alfresco"


IDX=$(( $IDX + 1 ))
params[$IDX]="db_name"
descr[$IDX]="Database name"
default[$IDX]="alfresco"


IDX=$(( $IDX + 1 ))
params[$IDX]="db_host"
descr[$IDX]="Database host. Not really useful yet. In future, if this is localhost then the DB will be installed locally, if anything  else then no local DB server is installed"
default[$IDX]="localhost"


IDX=$(( $IDX + 1 ))
params[$IDX]="db_port"
descr[$IDX]="Database port"
default[$IDX]="3306"


IDX=$(( $IDX + 1 ))
params[$IDX]="mem_xmx"
descr[$IDX]="Setting to pass as '-Xmx' for JAVA_OPTS"
default[$IDX]="32G"


IDX=$(( $IDX + 1 ))
params[$IDX]="mem_xxmaxpermsize"
descr[$IDX]="Setting to pass as '-XX:MaxPermSize' in JAVA_OPTS"
default[$IDX]="256m"
