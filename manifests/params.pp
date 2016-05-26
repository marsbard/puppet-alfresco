# Class: alfresco::params
#
#
class alfresco::params {

	$domain_name		= 'localhost'

	$initial_admin_pass	= 'admin'

	$mail_from_default	= 'admin@localhost'

	$alfresco_base_dir	= "/opt/alfresco"
	$tomcat_home		= "/opt/alfresco/tomcat"

	$alfresco_version	= "4.2.f"

	$download_path		= "/opt/downloads"

	$db_root_password	= "alfresco"
	$db_user		= "alfresco"
	$db_pass		= "alfresco"
	$db_name		= "alfresco"
	$db_host		= "localhost"
        $db_type                = "mysql"
        $db_port                = "3306"
        $db_driver              = "com.mysql.jdbc.Driver"
}
