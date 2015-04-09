
function write_output {

	domain_name=`get_param domain_name`
	initial_admin_pass=`get_param initial_admin_pass`
	mail_from_default=`get_param mail_from_default`
	alfresco_base_dir=`get_param alfresco_base_dir`
	tomcat_home=`get_param tomcat_home`
	alfresco_version=`get_param alfresco_version`
	download_path=`get_param download_path`
	db_root_password=`get_param db_root_password`
	db_user=`get_param db_user`
	db_pass=`get_param db_pass`
	db_name=`get_param db_name`
	db_host=`get_param db_host`
	db_port=`get_param db_port`
	mem_xmx=`get_param mem_xmx`
	mem_xxmaxpermsize=`get_param mem_xxmaxpermsize`
  ssl_cert_path=`get_param ssl_cert_path`

	echo -e "${GREEN}Writing puppet file ${BLUE}go.pp${WHITE}"
	cat > go.pp <<EOF
class { 'alfresco':
	domain_name => '${domain_name}',	
	initial_admin_pass => '${initial_admin_pass}',
	mail_from_default => '${mail_from_default}',	
	alfresco_base_dir => '${alfresco_base_dir}',	
	tomcat_home => '${tomcat_home}',	
	alfresco_version => '${alfresco_version}',	
	download_path => '${download_path}',	
	db_root_password => '${db_root_password}',
	db_user => '${db_user}',	
	db_pass => '${db_pass}',	
	db_name => '${db_name}',	
	db_host => '${db_host}',	
	db_port => '${db_port}',	
	mem_xmx => '${mem_xmx}',
	mem_xxmaxpermsize => '${mem_xxmaxpermsize}',
  ssl_cert_path => '${ssl_cert_path}',
}
EOF
	echo -e "${GREEN}Writing puppet file ${BLUE}test.pp${WHITE}"
	cat > test.pp <<EOF
class { 'alfresco::tests':
  delay_before => 10,
	domain_name => '${domain_name}',	
	initial_admin_pass => '${initial_admin_pass}',
	mail_from_default => '${mail_from_default}',	
	alfresco_base_dir => '${alfresco_base_dir}',	
	tomcat_home => '${tomcat_home}',	
	alfresco_version => '${alfresco_version}',	
	download_path => '${download_path}',	
	db_root_password => '${db_root_password}',
	db_user => '${db_user}',	
	db_pass => '${db_pass}',	
	db_name => '${db_name}',	
	db_host => '${db_host}',	
	db_port => '${db_port}',	
	mem_xmx => '${mem_xmx}',
	mem_xxmaxpermsize => '${mem_xxmaxpermsize}',
}
EOF
	sleep 1
}

write_output


