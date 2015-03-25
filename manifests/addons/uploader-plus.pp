class alfresco::addons::uploader-plus inherits alfresco::addons {

  exec { 'retrieve-uploaderplus-repo':
    command => 'wget https://github.com/softwareloop/uploader-plus/releases/download/v1.2/uploader-plus-repo-1.2.amp',
    cwd => "${alfresco_base_dir}/amps",
    path => '/usr/bin',
    creates => "${alfresco_base_dir}/amps/uploader-plus-repo-1.2.amp",
  }

  exec { 'retrieve-uploaderplus-share':
    command => 'wget https://github.com/softwareloop/uploader-plus/releases/download/v1.2/uploader-plus-surf-1.2.amp',
    cwd => "${alfresco_base_dir}/amps_share",
    path => '/usr/bin',
    creates => "${alfresco_base_dir}/amps_share/uploader-plus-surf-1.2.amp",
  }

}
