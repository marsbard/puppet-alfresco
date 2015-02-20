class alfresco::tests inherits alfresco {

  $delay_before = $delay_before_tests 


  # default wait is 3s, we may need a bit more
  $xvfb = "xvfb-run -a -e /dev/stdout --wait=9"

  case $::osfamily {
    'RedHat': {

      $packages = [ 
        'xorg-x11-server-Xvfb', 
        'python',
        'python-pip',
        'python-setuptools',
        'python-yaml',
        'firefox',
        'dejavu-sans-fonts',
        'dejavu-sans-mono-fonts',
        'dejavu-serif-fonts',
        'liberation-mono-fonts',
        'liberation-sans-fonts',
        'liberation-serif-fonts',
      ]


      file { "/usr/bin/xvfb-run":
        source => 'puppet:///modules/alfresco/xvfb-run',
        mode => '0755',
        ensure => present,
      }

    }
    'Debian': {

      $packages = [ 
        'python',
        'python-pip',
        'python-setuptools',
        'xvfb', 'x11-xkb-utils',
        'xfonts-100dpi', 'xfonts-75dpi', 
        'xfonts-scalable', 
        'xfonts-cyrillic', 
        'x11-apps',
        'python-yaml',
        'firefox',
      ]
    }
  }

  package {  $packages :
    ensure => latest,
  }

#  python::pip { 'cmislib':
#    #ensure => '0.5',
#    ensure => latest,
#    owner => 'root',
#    pkgname => 'configure',
#    require => Package['python-pip'],
#  }

  exec { "install-cmislib":
    command => "easy_install cmislib",
    path => '/usr/bin',
    creates => '/usr/local/lib/python2.7/dist-packages/cmislib-0.5.1-py2.7.egg',
  }

  python::pip { 'configure':
    owner => 'root',
    pkgname => 'configure',
    require => Package['python-pip'],
  }

  python::pip { 'configuration':
    owner => 'root',
    pkgname => 'configuration',
    require => Package['python-pip'],
  }

  python::pip { 'selenium':
    owner => 'root',
    pkgname => 'selenium',
    require => Package['python-pip'],
  }

  define runtest { 
	if $title =~ /^test_*py$/ {
		exec { $title:
			command =>  "${alfresco_base_dir}/tests/${title}",
			path => '/bin:/usr/bin',
		}
	}
  }

  define runalltests (
  ) {

	$tests = generate('/bin/cat /tmp/testlist')

	$arrTests = split($tests, ' ')

	runtest { $tests: }

  }


  vcsrepo { "${alfresco_base_dir}/tests":
	ensure => latest,
	provider => git,
	source => 'git://github.com/digcat/alfresco-tests.git',
	revision => 'master',
  } ->
  exec { "ugly-find-tests":
    command => "ls ${alfresco_base_dir}/tests/test_*.py > /tmp/testlist",
    path => '/bin',
  } ->
  file { "${alfresco_base_dir}/tests/config.yml":
    content => template('alfresco/tests-config.yml.erb'),
    ensure => present,
    require => Vcsrepo["${alfresco_base_dir}/tests"],
  } -> 
  exec { "delay-${delay_before}-before-tests":
    command => "/bin/sleep ${delay_before}",
  } ->
  runalltests { 'do-tests': 
    require => Exec['ugly-find-tests'],
  }

#  exec { "runtests-cmis":
#    cwd => "${alfresco_base_dir}/tests/alfresco-tests/",
#    command => "${xvfb} python test_cmis.py",
#    path => '/bin:/usr/bin',
#    require => [
#      File["${alfresco_base_dir}/tests/alfresco-tests/config.yml"],
#      Exec["install-cmislib"],
#      Service['alfresco-start'],
#      Exec["delay-${delay_before}-before-tests"],
#    ]
#  }
#
#  exec { "runtests-ftp":
#    cwd => "${alfresco_base_dir}/tests/alfresco-tests/",
#    command => "${xvfb} python test_ftp.py",
#    path => '/bin:/usr/bin',
#    require => [
#      File["${alfresco_base_dir}/tests/alfresco-tests/config.yml"],
#      Service['alfresco-start'],
#      Exec["delay-${delay_before}-before-tests"],
#    ]
#  }
#
#  exec { "runtests-swsdp":
#    cwd => "${alfresco_base_dir}/tests/alfresco-tests/",
#    command => "${xvfb} python ${testfile}",
#    path => '/bin:/usr/bin',
#    require => [
#      File["${alfresco_base_dir}/tests/alfresco-tests/config.yml"],
#      Service['alfresco-start'],
#      Exec["delay-${delay_before}-before-tests"],
#    ]
#  }



}
