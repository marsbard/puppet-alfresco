class alfresco::packages inherits alfresco {

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


    $packages = [
      "wget",
      "git",
      "zip",
      "unzip",
      "curl",
      "ghostscript",
      "haveged",
      "perl-Image-ExifTool",
			"ruby-devel",
    ]

    $rmpackages = [
      ]
    }

    'Debian': {

      if $java_version == 8 {
        $jpackage=""
        # auto accept oracle license: http://askubuntu.com/a/190674/33804

        class { 'apt': } ->
        apt::ppa { 'ppa:webupd8team/java': } ->
        # https://gist.github.com/tfnico/6d2b57642d21ebaa7574
        # update the apt keystore
        exec { 'apt-key-update':
          unless => "update-alternatives --list java|grep java-8-oracle 2>/dev/null",
          command => 'apt-key update',
          path => ['/usr/bin/','/bin/'],
        } ->
        # update apt sources
        exec { 'apt-update for oracle':
          unless => "update-alternatives --list java|grep java-8-oracle 2>/dev/null",
          command => 'apt-get update',
          path => ['/usr/bin/','/bin/'],
        } ->
        # set license acceptance with debconf
        exec { 'accept-java-license':
          unless => "update-alternatives --list java|grep java-8-oracle 2>/dev/null",
          command => 'echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | sudo /usr/bin/debconf-set-selections',
          path => ['/usr/bin/','/bin/'],
        } ~>
        # finally install the package
        # oracle-java6-installer and oracle-java7-installer also available from the ppa
        package { 'oracle-java8-installer':
          ensure => present,
        }

      } else {
        $jpackage="openjdk-7-jdk"
        alfresco::ensure_packages { "$jpackage": }
      }


      $packages = [
        "gdebi-core",
        "git",
        "unzip",
        "zip",
        "curl",
        "fonts-liberation",
        "fonts-droid-fallback",
        "imagemagick",
        "ghostscript",
        "libjpeg62",
        "libpng3",
        "haveged",
        "sudo",
        "libxinerama1",
        "libimage-exiftool-perl",
      ]
      $rmpackages = [
        "plymouth",
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


  alfresco::ensure_packages { $rmpackages:
    ensure => "absent",
  } ->
  alfresco::ensure_packages{ $packages:
    ensure => "installed",
  }
}
