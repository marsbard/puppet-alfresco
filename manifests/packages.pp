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
				"java-1.8.0-openjdk",
				#"java-1.7.0-openjdk",
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
				"gdebi-core",
				"git", 
				#"openjdk-7-jdk",
				#"openjdk-8-jdk",
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
        "oracle-java8-set-default",
		 	] 
			$rmpackages = [ 
				"openjdk-6-jdk",
		 		"openjdk-6-jre-lib",
        "openjdk-7-jdk",
        "openjdk-7-jre-lib",
			]
			exec { "apt-update":
			  command => "/usr/bin/apt-get update",
				schedule => "nightly",
			}

      include java8

		}
		default:{
			fail("Unsupported osfamily $osfamily")
		} 
	}

	schedule { 'nightly':
		period => daily,
		range  => "2 - 4",
	}

	define ensure_packages ($ensure = "present") {
       		if defined(Package[$title]) {} 
		else { 
			package { $title : ensure => $ensure, }
		}
     	}


  	ensure_packages{ $packages:
    		ensure => "installed", 
  	}

	ensure_packages { $rmpackages:
		ensure => "absent",
	}
}
