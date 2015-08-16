class alfresco::addons::aaar inherits alfresco::addons {

	$aaarbase = "https://github.com/fcorti/alfresco-audit-analysis-reporting/releases/download/v3.1"
	$aaarrepofile = "aaar-addon-v1.1-for-alfresco-CE-v5.0.x.amp"
	$aaarsharefile = "aaar-addon-v1.1-for-alfresco-share-CE-v5.0.x.amp"

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
