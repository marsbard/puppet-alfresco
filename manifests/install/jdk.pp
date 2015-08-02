class alfresco::install::jdk inherits alfresco {

  $java_version = 8

  case $::osfamily {

    'Debian': {

      $java_release = '8u45-b14-1'
      $java_base_url = 'http://mirrors.kernel.org/ubuntu/pool/universe/o/openjdk-8/'

      if $java_version == 8 {
        # packages not yet in trusty
        # get the vivid ones

        safe-download { 'openjdk-8-jre-headless':
          url => "${java_base_url}/openjdk-8-jre-headless_${java_release}.deb",
          filename => "openjdk-8-jre-headless_${java_release}.deb",
          download_path => $download_path,
        } -> exec {'gdebi-jre-headless':
          command => '/usr/bin/gdebi -n ${download_path}/openjdk-8-jre-headless_${java_release}.deb',
        }

        safe-download { 'openjdk-8-jre':
          url => "${java_base_url}/openjdk-8-jre_${java_release}.deb",
          filename => "openjdk-8-jre_${java_release}.deb",
          download_path => $download_path,
        } -> exec {'gdebi-jre':
          command => '/usr/bin/gdebi -n ${download_path}/openjdk-8-jre_${java_release}.deb',
        }

        safe-download { 'openjdk-8-jdk':
          url => "${java_base_url}/openjdk-8-jdk_${java_release}.deb",
          filename => "openjdk-8-jdk_${java_release}.deb",
          download_path => $download_path,
        } -> exec {'gdebi-jdk':
          command => '/usr/bin/gdebi -n ${download_path}/openjdk-8-jdk_${java_release}.deb',
        }


      } else {
        $jpackage="openjdk-7-jdk"
        ensure_packages { "$jpackage": }
      }
  }
  'RedHat': {
    if $java_version == 8 {
      $jpackage="java-1.8.0-openjdk"
    } else {
      $jpackage="java-1.7.0-openjdk"
    }
    package { $jpackage:
      ensure => installed,
    }
  }
}
