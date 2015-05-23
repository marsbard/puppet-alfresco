class alfresco::addons::aaar inherits alfresco::addons {

  $aaarsharefile = "aaar-alfresco-share-CE-v5.0.x.amp"
  $aaarrepofile = "aaar-alfresco-CE-v5.0.x.amp"

  $aaarbase = "http://downloads.sourceforge.net/project/aaar/Alfresco%20AMP%20packages/Alfresco%20CE%205.0.x"

  $aaarshareurl = "${aaarbase}/${aaarsharefile}"
  $aaarrepourl = "${aaarbase}/${aaarrepofile}"




  exec { 'retrieve-aaar-repo':
    command => "wget $aaarrepourl -O $aaarrepofile",
    cwd => "${alfresco_base_dir}/amps",
    creates => "${alfresco_base_dir}/amps/${aaarrepofile}",
    path => '/usr/bin',
  }


  exec { 'retrieve-aaar-share':
    command => "wget $aaarshareurl -O $aaarsharefile",
    cwd => "${alfresco_base_dir}/amps_share",
    creates => "${alfresco_base_dir}/amps_share/${aaarsharefile}",
    path => '/usr/bin',
  }

}
