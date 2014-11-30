
params[0]="domain_name"
descr[0]="Domain name at which the installation will be resolved, e.g. test.orderofthebee.org. This domain name must be resolvable to this machine."
default[0]=""
required[0]=1

params[1]="mail_from_default"
descr[1]="Default mail address to use in the 'From' field of sent mails"
default[1]="admin@localhost"

params[2]="alfresco_base_dir"
descr[2]="Where alfresco base folder should go, i.e. location of alf_data"
default[2]="/opt/alfresco"

params[3]="tomcat_home"
descr[3]="Where to install tomcat"
default[3]="/opt/alfresco/tomcat"

params[4]="alfresco_version"
descr[4]="Alfresco version to install. For now only '4.2.f' is supported"
default[4]="4.2.f"

params[5]="download_path"
descr[5]="Where to store downloaded files"
default[5]="/opt/downloads"

params[6]="db_root_password"
descr[6]="Password to use for root user when installing Mysql"
default[6]="alfresco"

params[7]="db_user"
descr[7]="Database user"
default[7]="alfresco"

params[8]="db_pass"
descr[8]="Database password"
default[8]="alfresco"

params[9]="db_name"
descr[9]="Database name"
default[9]="alfresco"

params[10]="db_host"
descr[10]="Database host. Not really useful yet. In future, if this is localhost then the DB will be installed locally, if anything  else then no local DB server is installed"
default[10]="localhost"

params[11]="db_port"
descr[11]="Database port"
default[11]="3306"

params[12]="mem_xmx"
descr[12]="Setting to pass as '-Xmx' for JAVA_OPTS"
default[12]="32G"

params[13]="mem_xxmaxpermsize"
descr[13]="Setting to pass as '-XX:MaxPermSize' in JAVA_OPTS"
default[13]="256m"
