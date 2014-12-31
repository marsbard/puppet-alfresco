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
	$mem_xmx			= "32G",
	$mem_xxmaxpermsize		= "256m"
) inherits alfresco::params {

	# all the URLs kept in here, if testing, you can create a 'urls-local.pp'
	# with nearer files and change this include. 
	include urls


	$admin_pass_hash = calc_ntlm_hash($initial_admin_pass)


	# add JAVA_OPTS with memory settings - TODO this won't work for CentOS
	$java_opts = "-Xmx${mem_xmx} -XX:MaxPermSize=${mem_xxmaxpermsize}"

	# at some point I'll use these for a non-allinone version. For now pre-empting
	# the change where I can but do not try editing these, please.
	$repo_host = $domain_name
	$share_host = $domain_name
	$solr_host = $domain_name
	

	case($alfresco_version){
		'4.2.f': {
			$alfresco_ce_url = $urls::alfresco_ce
		}
		default: {
			fail("Unsupported version ${alfresco_version}")
		}	
	}


	
  	case $::osfamily {
    		'RedHat': {
			$loffice_dl="${urls::loffice_dl_red}"
			$loffice_name="${urls::loffice_name_red}"
		}
		'Debian': {
			$loffice_dl="${urls::loffice_dl_deb}"
			$loffice_name="${urls::loffice_name_deb}"
		}
		default:{
			fail("Unsupported osfamily $osfamily")
		} 
	}
	$lo_install_loc = "/opt/libreoffice4.2"




	#$swftools_src_url = $urls::swftools_src_url
	






	#$name_tomcat = "apache-tomcat-7.0.55"
	#$filename_tomcat = "${name_tomcat}.tar.gz"
	#$url_tomcat = "http://archive.apache.org/dist/tomcat/tomcat-7/v7.0.55/bin/${filename_tomcat}"

	


	$keystorebase = "http://svn.alfresco.com/repos/alfresco-open-mirror/alfresco/HEAD/root/projects/repository/config/alfresco/keystore"


	#i#$mysql_connector_name = "mysql-connector-java-5.1.34"
	#$mysql_connector_file = "${mysql_connector_name}.tar.gz"
	#$mysql_connector_url = "http://dev.mysql.com/get/Downloads/Connector-J/${mysql_connector_file}"


# - oops this is for 5.0 ...
#	$solr_war_file = "alfresco-solr4-5.0.b-ssl.war"
#	$solr_war_dl = "https://artifacts.alfresco.com/nexus/service/local/repo_groups/public/content/org/alfresco/alfresco-solr4/5.0.b/$solr_war_file"
#	
#	$solr_cfg_file = "alfresco-solr4-5.0.b-config-ssl.zip"
#	$solr_cfg_dl = "https://artifacts.alfresco.com/nexus/service/local/repo_groups/public/content/org/alfresco/alfresco-solr4/5.0.b/$solr_cfg_file"


	#$solr_dl_file = "alfresco-community-solr-4.2.f.zip"
	#$solr_dl = "http://dl.alfresco.com/release/community/4.2.f-build-00012/${solr_dl_file}"



	#$swftools_name = "swftools-2013-04-09-1007"
	#$swftools_dl = "http://www.swftools.org/${swftools_name}.tar.gz"


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


	# for some reason packages are being applied out of order, so bind them to a run stage:
	stage { 'deps':
		before => Stage['main'],	
	}
	class { 'alfresco::packages':
		stage => 'deps',
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
