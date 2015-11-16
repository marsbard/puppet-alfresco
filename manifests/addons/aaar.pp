class alfresco::addons::aaar inherits alfresco::addons {

	$aaarbase = "https://github.com/fcorti/alfresco-audit-analysis-reporting/releases/download/v4.0"

case($alfresco_version){
      '4.2.f': {
          $aaarrepofile = "AAAR-Alfresco-CE-v4.2-Repository-v1.2.amp"
          $aaarsharefile = "AAAR-Alfresco-CE-v4.2-Share-v1.2.amp"
      }
  		'5.0.x': {
				  $aaarrepofile = "AAAR-Alfresco-CE-v5.0.d-Repository-v1.2.amp"
					$aaarsharefile = "AAAR-Alfresco-CE-v5.0.d-Share-v1.2.amp"
      }
			'5.1.x': {
          $aaarrepofile = "AAAR-Alfresco-CE-v5.1-Repository-v1.2.amp"
					$aaarsharefile = "AAAR-Alfresco-CE-v5.1-Share-v1.2.amp"
			}
			'NIGHTLY': {
          $aaarrepofile = "AAAR-Alfresco-CE-v5.1-Repository-v1.2.amp"
					$aaarsharefile = "AAAR-Alfresco-CE-v5.1-Share-v1.2.amp"
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
