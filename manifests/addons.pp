class alfresco::addons inherits alfresco {

  include alfresco::addons::rm
  include alfresco::addons::jsconsole

  # TODO work out the wrapping up of jar into amp correctly
  #class { 'alfresco::addons::webscripts':
  #}

  #class { 'alfresco::addons::filebrowser':
  #}

  class { 'alfresco::addons::ootbfrontpage':}

  class { 'alfresco::addons::monitorix': }

  class { 'alfresco::addons::ootbbeetheme':
    notify => Exec['apply-addons'],
  }

  # TODO this should be optional based on a parameter
  #class { 'alfresco::addons::aaar':
  #  notify => Exec['apply-addons'],
  #}

  class { 'alfresco::addons::uploader_plus':
    notify => Exec['apply-addons'],
  }

  class { 'alfresco::addons::googledocs':
    notify => Exec['apply-addons'],
  }

  class { 'alfresco::addons::reset_password':
    # it's a jar so just notify alfresco, not apply addons
    notify => Service['alfresco-start'],
  }

  exec { "apply-addons":
    require => [
      File["${alfresco_base_dir}/bin/apply_amps.sh"],
      File["${alfresco_base_dir}/bin/alfresco-mmt.jar"],
    ],
    path => "/bin:/usr/bin",
    command => "${alfresco_base_dir}/bin/apply_amps.sh",
    onlyif => "test ! -f ${tomcat_home}/webapps/alfresco*.bak",
    user => 'tomcat',
    notify => Service['alfresco-start'],
  }

  file { "${alfresco_base_dir}/bin/apply_amps.sh":
    ensure => present,
    mode => "0755",
    content => template("alfresco/apply_amps.sh.erb"),
    require => File["${alfresco_base_dir}/bin"],
    owner => 'tomcat',
  }

  file { "${alfresco_base_dir}/bin/clean_tomcat.sh":
    ensure => present,
    mode => '0755',
    #source => "${download_path}/alfresco/bin/clean_tomcat.sh",
    source => 'puppet:///modules/alfresco/clean_tomcat.sh',
    require => File["${alfresco_base_dir}/bin"],
    owner => 'tomcat',
  }
  
  file { "${alfresco_base_dir}/bin/clean_solrindex.sh":
    ensure => present,
    mode => '0755',
    #source => "${download_path}/alfresco/bin/clean_solrindex.sh",
    source => 'puppet:///modules/alfresco/clean_solrindex.sh',
    require => File["${alfresco_base_dir}/bin"],
    owner => 'tomcat',
  }

  file { "${alfresco_base_dir}/bin/makeimagemagicklink.sh":
    ensure => present,
    mode => '0755',
    content => template('alfresco/makeimagemagicklink.sh.erb'),
    require => File["${alfresco_base_dir}/bin"],
    owner => 'tomcat',
    notify => Service['tomcat'],
  } 

  exec { "check_imagemagicklink":
    command => '/bin/true',
    onlyif => "/usr/bin/test -e ${alfresco_base_dir}/ImageMagickCoders",
  }

  exec { "makeimagemagicklink":
    path => "/bin:/usr/bin",
    command => "${alfresco_base_dir}/bin/makeimagemagicklink.sh",
    creates => "${alfresco_base_dir}/ImageMagickCoders/",
    notify => Service['tomcat'],
    require => Exec["check_imagemagicklink"],
  }


  file { "${alfresco_base_dir}/bin/alfresco-mmt.jar":
    ensure => present,
    mode => '0755',
    #source => "${download_path}/alfresco/bin/alfresco-mmt.jar",
    source => 'puppet:///modules/alfresco/alfresco-mmt.jar',
    require => File["${alfresco_base_dir}/bin"],
    owner => 'tomcat',
  }

  #exec { "fix-war-permissions":
  #  path => "/bin:/usr/bin",
  #  command => "chown tomcat ${tomcat_home}/webapps/*.war; chmod a+r ${tomcat_home}/webapps/*.war",
  #  onlyif => [
  #    "test -f ${tomcat_home}/webapps/alfresco.war  && ls -l ${tomcat_home}/webapps/alfresco.war | xargs | cut -f3 -d\  | grep tomcat",
  #    "test -f ${tomcat_home}/webapps/share.war  && ls -l ${tomcat_home}/webapps/share.war | xargs | cut -f3 -d\  | grep tomcat",
  #    "test -r ${tomcat_home}/webapps/alfresco.war",
  #    "test -r ${tomcat_home}/webapps/share.war",
  #  ]
  #}

#  exec { "unpack-alfresco-war":
#    require => [
#      Exec["${tomcat_home}/webapps/alfresco.war"],
#      Exec['apply-addons'],
#    ],
#    path => "/bin:/usr/bin",
#    command => "unzip -o -d ${tomcat_home}/webapps/alfresco ${tomcat_home}/webapps/alfresco.war && chown -R tomcat ${tomcat_home}/webapps/alfresco",
#    creates => "${tomcat_home}/webapps/alfresco/",
#    notify => Service['tomcat'],
#  }
#
#  exec { "unpack-share-war":
#    require => [
#      Exec["${tomcat_home}/webapps/share.war"],
#      Exec['apply-addons'],
#    ],
#    path => "/bin:/usr/bin",
#    command => "unzip -o -d ${tomcat_home}/webapps/share ${tomcat_home}/webapps/share.war && chown -R tomcat ${tomcat_home}/webapps/share",
#    creates => "${tomcat_home}/webapps/share/",
#    notify => Service['tomcat'],
#  }

}
