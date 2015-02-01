class alfresco::packages inherits alfresco {

  	case $::osfamily {
    	'RedHat': {

			exec { "get-repoforge":
				command => "yum install -y http://pkgs.repoforge.org/rpmforge-release/rpmforge-release-0.5.3-1.el6.rf.x86_64.rpm",
				path => "/bin:/usr/bin",
				creates => "/etc/yum.repos.d/rpmforge.repo",
				
			}

      class { 'epel':
      }

			Class['epel'] -> Exec["get-repoforge"] -> Package <| |>


		  $packages = [ 
				"git", 
				"java-1.7.0-openjdk",
		 		"unzip",
				"curl",
				"ghostscript", 
				"haveged",
		 	] 
			$rmpackages = [ 
			]
		}
		'Debian': {
		  $packages = [ 
        "dos2unix",
        "sudo",
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
        "sudo",
		 	] 
			$rmpackages = [ 
				"openjdk-6-jdk",
		 		"openjdk-6-jre-lib",
			]
			exec { "apt-update":
			  command => "/usr/bin/apt-get update",
				schedule => "nightly",
			}
		}
		default:{
			fail("Unsupported osfamily $osfamily")
		} 
	}

	schedule { 'nightly':
		period => daily,
		range  => "2 - 4",
	}



  package { $packages:
    ensure => "installed", 
  }

	package { $rmpackages:
		ensure => "absent",
	}
}
