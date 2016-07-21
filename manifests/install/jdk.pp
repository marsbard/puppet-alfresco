class alfresco::install::jdk inherits alfresco {

  $java_version = 8

  case $::osfamily {

    'Debian': {

			# TODO this URL stuff should be in urls.pp!
			# http://mirrors.kernel.org/ubuntu/pool/universe/o/openjdk-8/openjdk-8-jre-headless_8u91-b14-0ubuntu4~15.10.1_amd64.deb

      # $java_release = '8u45-b14-1'
      $java_release = '8u91-b14-0ubuntu4~15.10.1'
      $java_base_url = 'http://mirrors.kernel.org/ubuntu/pool/universe/o/openjdk-8'

      if $java_version == 8 {
        # packages not yet in trusty
        # get the vivid ones

        alfresco::safe_download { 'openjdk-8-jre-headless':
          url => "${java_base_url}/openjdk-8-jre-headless_${java_release}_amd64.deb",
          filename => "openjdk-8-jre-headless_${java_release}_amd64.deb",
          download_path => $download_path,
        } -> exec {'gdebi-jre-headless':
          command => "/usr/bin/gdebi -n ${download_path}/openjdk-8-jre-headless_${java_release}_amd64.deb",
        } ->
        alfresco::safe_download { 'openjdk-8-jre':
          url => "${java_base_url}/openjdk-8-jre_${java_release}_amd64.deb",
          filename => "openjdk-8-jre_${java_release}_amd64.deb",
          download_path => $download_path,
        } -> exec {'gdebi-jre':
          command => "/usr/bin/gdebi -n ${download_path}/openjdk-8-jre_${java_release}_amd64.deb",
        } ->
        alfresco::safe_download { 'openjdk-8-jdk':
          url => "${java_base_url}/openjdk-8-jdk_${java_release}_amd64.deb",
          filename => "openjdk-8-jdk_${java_release}_amd64.deb",
          download_path => $download_path,
        } -> exec {'gdebi-jdk':
          command => "/usr/bin/gdebi -n ${download_path}/openjdk-8-jdk_${java_release}_amd64.deb",
        }


      } else {
        $jpackage="openjdk-7-jdk"
        alfresco::ensure_packages { "$jpackage": }
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
}
