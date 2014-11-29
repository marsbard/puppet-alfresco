# == Class: alfresco
#
# A class to install Alfresco CE
#
# === Parameters
#
# [*domain_name*]
# Domain name at which the installation will be resolved, e.g.
# 'test.orderofthebee.org'
#
# [*alfresco_base_dir*]
# Where alfresco base folder is, i.e. location of alf_data. Defaults
# to '/opt/alfresco'
#
# [*tomcat_home*]
# Where to install tomcat. Defaults to '/opt/alfresco/tomcat'
#
# [*mail_from_default*]
# Default mail address to use in the 'From' field of sent mails
#
# [*alfresco_version*]
# For now only '4.2.f' is supported
#
# [*download_path*]
# Where to store downloaded files. Defaults to '/opt/downloads'
#
# [*db_root_password*]
# Root password to use when setting up mysql
#
# [*db_user*]
# Database user. Defaults to 'alfresco'
#
# [*db_pass*]
# Password for database user. Defaults to 'alfresco'
#
# [*db_name*]
# Name of database. Defaults to 'alfresco'
#
# [*db_host*]
# Hostname of database. Not really useful yet. In future, if this
# is localhost then the DB will be installed locally, if anything
# else then no local DB server is installed
#
# [*db_port*]
# Port of DB server. Default to 3306.
#
# === Examples
#
#  class { 'alfresco':
#	domain_name => "test.orderofthebee.org",
#	mail_from_default => "admin@test.orderofthebee.org",
#  }
#
# === Authors
#
# Author Name <author@example.com>
#
# === Copyright
#
# Copyright 2011 Your name here, unless otherwise noted.
#

class alfresco (
	$domain_name			= $alfresco::params::domain_name,
	$initial_admin_pass		= $alfresco::params::initial_admin_pass,
	$mail_from_default		= $alfresco::params::mail_from_default,	
	$alfresco_base_dir		= $alfresco::params::alfresco_base_dir,
	$tomcat_home			= $alfresco::params::tomcat_home,
	$alfresco_version		= $alfresco::params::alfresco_version,
	$download_path			= $alfresco::params::download_path,
	$db_root_password		= $alfresco::params::db_root_password	,
	$db_user			= $alfresco::params::db_user,
	$db_pass			= $alfresco::params::db_pass,
	$db_name			= $alfresco::params::db_name,
	$db_host			= $alfresco::params::db_host,
	$db_port			= 3306,
) inherits alfresco::params {


	#$admin_pass_hash = calc_ntlm_hash($admin_pass)

	

	case($alfresco_version){
		'4.2.f': {
			$alfresco_ce_filename = "alfresco-community-4.2.f.zip"
			$alfresco_ce_url = "http://dl.alfresco.com/release/community/4.2.f-build-00012/${alfresco_ce_filename}"
		}
		default: {
			# TODO: err exit() nonexistent!
			notice("Unsupported version ${alfresco_version}")
		}	
	}


	
  	case $::osfamily {
    		'RedHat': {
			$loffice_name = "LibreOffice_4.2.7.2_Linux_x86-64_rpm"
			$loffice_dl = "http://downloadarchive.documentfoundation.org/libreoffice/old/4.2.7.2/rpm/x86_64/${loffice_name}.tar.gz"

		}
		'Debian': {
			$loffice_name = "LibreOffice_4.2.7.2_Linux_x86-64_deb"
			$loffice_dl= "http://downloadarchive.documentfoundation.org/libreoffice/old/4.2.7.2/deb/x86_64/${loffice_name}.tar.gz"

		}
		default:{
			exit("Unsupported osfamily $osfamily")
		} 
	}

	$share_host = $domain_name
	$repo_host = $domain_name


	$swftools_src_name = "swftools-2013-04-09-1007"
	$swftools_src_url = "http://www.swftools.org/${swftools_src_name}.tar.gz"
	$lo_install_loc = "/opt/libreoffice4.2"

	$name_tomcat = "apache-tomcat-7.0.55"
	$filename_tomcat = "${name_tomcat}.tar.gz"
	$url_tomcat = "http://archive.apache.org/dist/tomcat/tomcat-7/v7.0.55/bin/${filename_tomcat}"


	$keystorebase = "http://svn.alfresco.com/repos/alfresco-open-mirror/alfresco/HEAD/root/projects/repository/config/alfresco/keystore"


	$mysql_connector_name = "mysql-connector-java-5.1.34"
	$mysql_connector_file = "${mysql_connector_name}.tar.gz"
	$mysql_connector_url = "http://dev.mysql.com/get/Downloads/Connector-J/${mysql_connector_file}"


# - oops this is for 5.0 ...
#	$solr_war_file = "alfresco-solr4-5.0.b-ssl.war"
#	$solr_war_dl = "https://artifacts.alfresco.com/nexus/service/local/repo_groups/public/content/org/alfresco/alfresco-solr4/5.0.b/$solr_war_file"
#	
#	$solr_cfg_file = "alfresco-solr4-5.0.b-config-ssl.zip"
#	$solr_cfg_dl = "https://artifacts.alfresco.com/nexus/service/local/repo_groups/public/content/org/alfresco/alfresco-solr4/5.0.b/$solr_cfg_file"


	$solr_dl_file = "alfresco-community-solr-4.2.f.zip"
	$solr_dl = "http://dl.alfresco.com/release/community/4.2.f-build-00012/${solr_dl_file}"



	$swftools_name = "swftools-2013-04-09-1007"
	$swftools_dl = "http://www.swftools.org/${swftools_name}.tar.gz"


	$alfresco_db_name = $db_name
	$alfresco_db_user = $db_user
	$alfresco_db_pass = $db_pass
	$alfresco_db_host = $db_host
	$alfresco_db_port = $db_port
	

	$alfresco_unpacked = "${download_path}/alfresco"
	$alfresco_war_loc = "${alfresco_unpacked}/web-server/webapps"




	#http://askubuntu.com/a/519783/33804
	if($osfamily == 'Debian'){
		exec{ "reinstall-bsdutils":
			command => "apt-get -y --reinstall install bsdutils",
			path => "/bin:/usr/bin:/sbin:/usr/sbin",	
			creates => "/usr/bin/logger", # <-- this is what is missing on some ubuntu installs		
		}
	}



	anchor { 'alfresco::begin': } ->
	class { 'alfresco::install': } ->
	class { 'alfresco::addons': } ->
	class { 'alfresco::config': 
		notify => Class['alfresco::service'],
	} ->
	class { 'alfresco::service': } ->
	anchor { 'alfresco::end': }
	
}
