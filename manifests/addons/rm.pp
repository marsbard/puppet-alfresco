class alfresco::addons::rm inherits alfresco::addons {

  case($alfresco_version){
		'4.2.f': {
			$recmanpath = 'http://download2.polytechnic.edu.na/pub4/sourceforge/a/al/alfresco/Alfresco%204.2.f%20Community'
			$recmanfile = 'alfresco-rm-2.1.a-621.zip'
			$recmanrepo = 'alfresco-rm-2.1.0-621.amp'
			$recmanshare = 'alfresco-rm-share-2.1.0-621.amp'

			# MC assuming that this is the correct creates for 4.2.f, certainly isn't for 5.0.x
			$recmancreates = "${download_path}/rm/README.txt"
		}	
		'5.0.x','NIGHTLY':{
			$recmanpath = 'http://dl.alfresco.com/release/community/5.0.d-build-00002'
			$recmanfile = 'alfresco-rm-2.3.c.zip'
			$recmanrepo = 'alfresco-rm-server-2.3.c.amp'
			$recmanshare = 'alfresco-rm-share-2.3.c.amp'
			$recmancreates = "${download_path}/rm/${recmanrepo}"
		}	
		default: {
			fail("Unsupported version ${alfresco_version}")	
		}	
  }
	$filename_rm = $recmanfile
	$url_rm = "${recmanpath}/${filename_rm}"
	$rm_repo = $repofilename 
	$rm_share = $sharefilename

	safe-download { 'addons::rm':
		url => $url_rm,
		filename => $filename_rm,
		download_path => $download_path,
	}
	
  exec { "unpack-rm":
    user => 'tomcat',
    creates => "${recmancreates}",
    cwd => "${download_path}/rm",
    command => "unzip -o ${download_path}/${filename_rm}",
    require => [
      File["${download_path}/rm"],
			Safe-download['addons::rm'],
			Package["unzip"],
    ],
    path => "/usr/bin",
  }


  file { "${download_path}/rm":
    ensure => directory,
    before => Exec["unpack-rm"],
    owner => 'tomcat',
  }

  file { "${alfresco_base_dir}/amps/${recmanrepo}":
    source => "${download_path}/rm/${recmanrepo}",
    ensure => present,
    require => [
      Exec["unpack-rm"],
    ],
		notify => Exec["apply-addons"],
    owner => 'tomcat',
  }

  file { "${alfresco_base_dir}/amps_share/${recmanshare}":
    source => "${download_path}/rm/${recmanshare}",
    ensure => present,
    require => [
      Exec["unpack-rm"],
    ],
		notify => Exec["apply-addons"],
    owner => 'tomcat',
  }


}

