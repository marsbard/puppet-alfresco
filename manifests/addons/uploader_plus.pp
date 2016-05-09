class alfresco::addons::uploader_plus inherits alfresco::addons {

  alfresco::safe_download { 'addons::uploader_plus-repo':
    url => 'https://github.com/softwareloop/uploader-plus/releases/download/v1.2/uploader-plus-repo-1.2.amp',
    filename => 'uploader-plus-repo-1.2.amp',
    download_path => "${alfresco_base_dir}/amps",
  }

  alfresco::safe_download { 'addons::uploader_plus-share':
    url => 'https://github.com/softwareloop/uploader-plus/releases/download/v1.2/uploader-plus-surf-1.2.amp',
    filename => 'uploader-plus-surf-1.2.amp',
    download_path => "${alfresco_base_dir}/amps_share",
  }

}
