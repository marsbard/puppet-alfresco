class alfresco::addons::aaar inherits alfresco::addons {

  $aaarsharefile = "aaar-alfresco-share-CE-v5.0.x.amp"
  $aaarrepofile = "aaar-alfresco-CE-v5.0.x.amp"

  $aaarbase = "http://downloads.sourceforge.net/project/aaar/Alfresco%20AMP%20packages/Alfresco%20CE%205.0.x"

  $aaarshareurl = "${aaarbase}/${aaarsharefile}"
  $aaarrepourl = "${aaarbase}/${aaarrepofile}"


	safe-download { 'aaar-repo':
		url => $aaarrepourl,
		filename => $aaarrepofile,
		download_path => "${alfresco_base_dir}/amps",
	}

	safe-download { 'aaar-share':
		url => $aaarshareurl,
		filename => $aaarsharefile,
		download_path => "${alfresco_base_dir}/amps_share",
	}

}
