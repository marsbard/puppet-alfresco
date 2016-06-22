class alfresco::dbdetails {

  $mysql_connector_version = '5.1.39'
  $mysql_root = "https://repo1.maven.org"
  $mysql_location = "maven2/mysql/mysql-connector-java/${mysql_connector_version}"
  $mysql_connector_name = "mysql-connector-java-${mysql_connector_version}"
  $mysql_connector_file = "${mysql_connector_name}.jar"
  $mysql_connector_url = "${mysql_root}/${mysql_location}/${mysql_connector_file}"
  $mysql_driver = "com.mysql.jdbc.Driver"
  $mysql_params = "?useUnicode=yes&characterEncoding=UTF-8&autoReconnect=true"
  $mysql_default_port = "3306"

  $postgresql_connector_version = "9.4.1208"
  $postgresql_root = "https://jdbc.postgresql.org"
  $postgresql_location = "download"
  $postgresql_connector_name = "postgresql-${postgresql_connector_version}"
  $postgresql_connector_file = "${postgresql_connector_name}.jar"
  $postgresql_connector_url = "${postgresql_root}/${postgresql_location}/${postgresql_connector_file}"
  $postgresql_driver = "org.postgresql.Driver"
  $postgresql_params = ""
  $postgresql_default_port = "5432"
  

  if $db_type == "mysql" {
  
  }
  if $db_type == "postgresql" {

  }
}
