class alfresco::addons::ootbbeetheme inherits alfresco::addons {

	safe-download { 'addons::ootbbeetheme-share':
		url => 'https://github.com/digcat/honeycomb-beeTheme/releases/download/1.0.0/alfrescoThemes_beeTheme.amp',
		filename => 'alfrescoThemes_beeTheme.amp',
		download_path => "${alfresco_base_dir}/amps_share",
	}

}
