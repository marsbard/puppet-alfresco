class alfresco::addons::aaar inherits alfresco::addons {

	$aaarbase = "https://github.com/fcorti/alfresco-audit-analysis-reporting/releases/download/v3.1"

case($alfresco_version){
      '4.2.f': {
          $aaarrepofile = "aaar-repo-v1.1-for-alfresco-CE-v4.2.x.amp"
          $aaarsharefile = "aaar-share-v1.1-for-alfresco-CE-v4.2.x.amp"
      }
  		'5.0.x','NIGHTLY': {
				  $aaarrepofile = "aaar-repo-v1.1-Alfresco-CE-v5.0.d.amp"
					$aaarsharefile = "aaar-share-v1.1-Alfresco-CE-v5.0.d.amp"
      }
}
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
