class alfresco::packages inherits alfresco {

  $java_version = 8

  define ensure_packages ($ensure = "present") {
    if defined(Package[$title]) {}
    else {
      package { $title : ensure => $ensure, }
    }
  }


  case $::osfamily {
    'RedHat': {

    exec { "get-repoforge":
      command => "yum install -y http://pkgs.repoforge.org/rpmforge-release/rpmforge-release-0.5.3-1.el${operatingsystemmajrelease}.rf.x86_64.rpm",
      path => "/bin:/usr/bin",
      creates => "/etc/yum.repos.d/rpmforge.repo",
    }

    # TODO no idea if this is actually effective
    exec { "guard-against-prev-broken":
      #command => "yum clean all; yum clean headers; yum complete-transaction",
      command => "yum clean all; yum clean headers",
      path => "/bin:/usr/bin",
    }

    class { 'epel':
    }

    Exec['guard-against-prev-broken'] -> Class['epel'] -> Exec["get-repoforge"] -> Package <| |>

    if $java_version == 8 {
      $jpackage="java-1.8.0-openjdk"
    } else {
      $jpackage="java-1.7.0-openjdk"
    }

    $packages = [
      "wget",
      "git",
      $jpackage,
      "zip",
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
	apt::ppa { 'ppa:webupd8team/java': }
	package { 'oracle-java8-installer': 
          ensure => installed,
        }
      } else {
        $jpackage="openjdk-7-jdk"
        ensure_packages { "$jpackage": }
      }


      $packages = [
        "gdebi-core",
        "git",
        "unzip",
        "zip",
        "curl",
        "fonts-liberation",
        "fonts-droid",
        "imagemagick",
        "ghostscript",
        "libjpeg62",
        "libpng3",
        "haveged",
        "sudo",
        "libxinerama1",
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

  ensure_packages{ $packages:
    ensure => "installed",
  }

  ensure_packages { $rmpackages:
    ensure => "absent",
  }
}
