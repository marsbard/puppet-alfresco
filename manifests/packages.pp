class alfresco::packages inherits alfresco {

  $java_version=8

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


      if $java_version == 8 {
        $jpackage="java-1.8.0-openjdk"
      } else {
        $jpackage="java-1.7.0-openjdk"
      }

		  $packages = [ 
				"git", 
        $jpackage,
		 		"unzip",
				"curl",
				"ghostscript", 
				"haveged",
		 	] 

			$rmpackages = [ 
			]
		}
		'Debian': {
      
      if $java_version == 8 {
        $jpackage=""
        include java8
        package{ 'oracle-java8-set-default':
          require => Class['java8'],
        }
      } else {
        $jpackage="openjdk-7-jdk"
				ensure_packages $jpackage
      }


		  $packages = [ 
				"gdebi-core",
				"git", 
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
