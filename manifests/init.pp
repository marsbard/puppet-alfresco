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
# '4.2.f', '5.0.x', or 'NIGHTLY'
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
# [*mail_host*]
# Address of mail server who will accept mail from us. If left as 
# 'localhost' then postfix will be installed locally
#
# [*mem_xmx*]
# Equivalent to the -Xmx switch
#
# [*mem_xxmaxpermsize*]
# Equivalent to the -XX:MaxPermSize switch
#
#
#
# === Examples
#
#  class { 'alfresco':
#  domain_name => "test.orderofthebee.org",
#  mail_from_default => "admin@test.orderofthebee.org",
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
  $download_path		= $alfresco::params::download_path,
  $db_root_password		= $alfresco::params::db_root_password	,
  $db_user			= $alfresco::params::db_user,
  $db_pass			= $alfresco::params::db_pass,
  $db_name			= $alfresco::params::db_name,
  $db_host			= $alfresco::params::db_host,
  $db_port			= $alfresco::params::db_port,
  $db_type                      = $alfresco::params::db_type,
  $mail_host                    = 'localhost',
  $mail_port                    = 25,
  $mem_xmx			= "32G",
  $mem_xxmaxpermsize		= "512m",
  $delay_before_tests           = 1,
  $apt_cache_host               = '',
  $apt_cache_port               = 3142,
  $ssl_cert_path                = '',
  $enable_proxy                 = true
) inherits alfresco::params {

  include alfresco::urls
  include alfresco::dbdetails

  $admin_pass_hash = calc_ntlm_hash($initial_admin_pass)

  notice("alfresco_version = ${alfresco_version}")

  # add JAVA_OPTS with memory settings - TODO this won't work for CentOS
  $java_opts = "-Xmx${mem_xmx} -Xms${mem_xmx} -XX:MaxPermSize=${mem_xxmaxpermsize} -server"

  # at some point I'll use these for a non-allinone version. For now pre-empting
  # the change where I can but do not try editing these, please.
  $repo_host = $domain_name
  $share_host = $domain_name
  $solr_host = $domain_name


  case($alfresco_version){
    '4.2.f': {
      $alfresco_ce_url = $alfresco::urls::alfresco_ce_url
      $indexer = 'solr'
      $cmis_url = '/alfresco/s/cmis'
      $java_version = 7
    }
    '5.0.x', 'NIGHTLY': {
      $indexer = 'solr4'
      $cmis_url = '/alfresco/cmisatom'
      $java_version = 8
    }
    default: {
      fail("Unsupported version ${alfresco_version}")
    }	
  }

 case($db_type){
    'mysql': {
       $alfresco_db_driver = "${alfresco::dbdetails::mysql_driver}"
       $alfresco_db_params = "${alfresco::dbdetails::mysql_params}"
    }
    'postgresql': {
       $alfresco_db_driver = "${alfresco::dbdetails::postgresql_driver}"       
       $alfresco_db_params = "${alfresco::dbdetails::postgresql_params}"
    }
    default: {
      fail("Database not supported ${alfresco::params::db_type}")
    }
 }

 case $::osfamily {
  'RedHat': {
    $loffice_dl="${alfresco::urls::loffice_dl_red}"
    $loffice_name="${alfresco::urls::loffice_name_red}"
    #$img_coders = "/usr/lib64/ImageMagick-6.7.8/modules-Q16/coders"
  }
  'Debian': {
    $loffice_dl="${alfresco::urls::loffice_dl_deb}"
    $loffice_name="${alfresco::urls::loffice_name_deb}"
    #$img_coders = "/usr/lib/x86_64-linux-gnu/ImageMagick-6.7.7/modules-Q16/coders"
  }
  default:{
    fail("Unsupported osfamily $osfamily")
  } 
 }
  $lo_install_loc = "/opt/libreoffice4.2"

  $keystorebase = "http://svn.alfresco.com/repos/alfresco-open-mirror/alfresco/HEAD/root/projects/repository/config/alfresco/keystore"

  $alfresco_db_name = $db_name
  $alfresco_db_user = $db_user
  $alfresco_db_pass = $db_pass
  $alfresco_db_host = $db_host
  $alfresco_db_port = $db_port
  $alfresco_db_type = $db_type

  $alfresco_unpacked = "${download_path}/alfresco"
  $alfresco_war_loc = "${alfresco_unpacked}/web-server/webapps"



  # write a config file for BART, will also make the templated files refer to these:
  file { "${alfresco_base_dir}/scripts":
    ensure => directory,
    require => File[$alfresco_base_dir],
  } -> 
  file { "${alfresco_base_dir}/scripts/bart.conf":
    ensure => present,
    content => "ALF_BASE_DIR=${alfresco_base_dir}\nINDEXER=${indexer}\nDB_NAME=${db_name}\nDB_PASS=${db_pass}\nDB_HOST=${db_host}\nDB_USER=${db_user}\n"
  }


  file { "/opt":
    ensure => directory,
  }


  #http://askubuntu.com/a/519783/33804
  if($osfamily == 'Debian'){
    exec{ "reinstall-bsdutils":
    command => "apt-get -y --reinstall install bsdutils",
    path => "/bin:/usr/bin:/sbin:/usr/sbin",	
    creates => "/usr/bin/logger", # <-- this is what is missing on some ubuntu installs		
    }
  }

  # on centos - no suitable provider for cron
  if($osfamily == 'RedHat'){
    package { 'cronie':
      ensure => installed,
      before => Class['alfresco::install'],
    }
  }	

  # for some reason packages are being applied out of order, so bind them to a run stage:
  stage { 'deps':
   before => Stage['main'],	
  }
  class { 'alfresco::packages':
   stage => 'deps',
  }
  stage { 'aptcache':
   before => Stage['deps'],
  }
  class { 'alfresco::aptcache':
    stage => 'aptcache',
  }
  stage { 'nightly':
    before => Stage['main'],
  }
  class { 'alfresco::nightly':
  }

  anchor { 'alfresco::begin': } ->
  class { 'alfresco::install': } ->
  class { 'alfresco::install::solr': } ->
  class { 'alfresco::addons': } ->
  class { 'alfresco::config': 
     notify => Class['alfresco::service'],
  } ->
  class { 'alfresco::service': } ->
  anchor { 'alfresco::end': }

}
