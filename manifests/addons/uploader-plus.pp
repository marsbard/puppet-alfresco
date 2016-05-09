class alfresco::addons::uploader-plus inherits alfresco::addons {

  safe_download { 'addons::uploader-plus-repo':
    url => 'https://github.com/softwareloop/uploader-plus/releases/download/v1.2/uploader-plus-repo-1.2.amp',
    filename => 'uploader-plus-repo-1.2.amp',
    download_path => "${alfresco_base_dir}/amps",
  }

  safe_download { 'addons::uploader-plus-share':
    url => 'https://github.com/softwareloop/uploader-plus/releases/download/v1.2/uploader-plus-surf-1.2.amp',
    filename => 'uploader-plus-surf-1.2.amp',
    download_path => "${alfresco_base_dir}/amps_share",
  }

}
