class alfresco::addons::googledocs inherits alfresco::addons {
  case($alfresco_version){
        '4.2.f': {
		$gdrepofile = "alfresco-googledocs-repo-2.0.7-18com.amp"
		$gdrepourl = "http://dl.alfresco.com/release/community/4.2.f-build-00012/${gdrepofile}"
		$gdsharefile = "alfresco-googledocs-share-2.0.7-18com.amp"
		$gdshareurl = "http://dl.alfresco.com/release/community/4.2.f-build-00012/${gdsharefile}"
	} 
	'5.0.x','NIGHTLY': {
  		$gdrepofile = "alfresco-googledocs-repo-3.0.0.amp"
  		$gdrepourl = "https://artifacts.alfresco.com/nexus/service/local/repositories/releases/content/org/alfresco/integrations/alfresco-googledocs-repo/3.0.0/${gdrepofile}"
  		$gdsharefile = "alfresco-googledocs-share-3.0.0.amp"
  		$gdshareurl = "https://artifacts.alfresco.com/nexus/service/local/repositories/releases/content/org/alfresco/integrations/alfresco-googledocs-share/3.0.0/${gdsharefile}"
	}
  }

  exec { 'retrieve-repo':
    command => "wget $gdrepourl",
    cwd => "${alfresco_base_dir}/amps",
    creates => "${alfresco_base_dir}/amps/${gdrepofile}",
    path => '/usr/bin',
  }
  



  exec { 'retrieve-share':
    command => "wget $gdshareurl",
    cwd => "${alfresco_base_dir}/amps_share",
    creates => "${alfresco_base_dir}/amps_share/${gdsharefile}",
    path => '/usr/bin',
  }
  
}
