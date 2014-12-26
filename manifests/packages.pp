class alfresco::packages inherits alfresco {

  case $::osfamily {
    'RedHat': {

			class {'epel':}

			exec { "get-repoforge":
				command => "yum install -y http://pkgs.repoforge.org/rpmforge-release/rpmforge-release-0.5.3-1.el6.rf.x86_64.rpm",
				path => "/bin:/usr/bin",
				creates => "/etc/yum.repos.d/rpmforge.repo",
				
			}

			Exec["get-repoforge"] -> Package <| |>


		  $packages = [ 
				"git", 
				"java-1.7.0-openjdk",
		 		"unzip",
				"curl",
				"ghostscript", 
				"haveged",
				"ImageMagick",
		 	] 
			
      $rmpackages = [ 
			]
    }
		'Debian': {
		  $packages = [ 
				"gdebi-core",
				"git", 
				"openjdk-7-jdk",
		 		"unzip",
				"curl",
				"fonts-liberation", 
				"fonts-droid", 
				"imagemagick", 
				"ghostscript", 
				"libjpeg62", 
				"libpng3",
				"haveged",
		 	] 
			$rmpackages = [ 
				"openjdk-6-jdk",
		 		"openjdk-6-jre-lib",
			]
		}
		default:{
			fail("Unsupported osfamily $osfamily")
		} 
	}


  package { $packages:
    ensure => "installed", 
    #allow_virtual => false,
  }

	package { $rmpackages:
		ensure => "absent",
	}
}
