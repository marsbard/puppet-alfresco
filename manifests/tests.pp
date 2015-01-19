class alfresco::tests ( 
  $delay_before = 120 
) inherits alfresco {

  $testsrc = 'digcat' 
  $testfile = 'test_ex_swsdp.py'
  
  #$testsrc = 'marsbard' 
  #$testfile = 'test_swsdp.py'

  # default wait is 3s, we may need a bit more
  $xvfb = "xvfb-run -a -e /dev/stdout --wait=9"

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

  exec { "clone-digcat-tests":
    command => "git clone https://github.com/${testsrc}/alfresco-tests.git",
    path => "/usr/bin",
    cwd => "${alfresco_base_dir}/tests",
    require => File["${alfresco_base_dir}/tests"],
    creates => "${alfresco_base_dir}/tests/alfresco-tests",
  }

  file { "${alfresco_base_dir}/tests":
    ensure => directory,
  }

  file { "${alfresco_base_dir}/tests/alfresco-tests/config.yml":
    content => template('alfresco/tests-config.yml.erb'),
    ensure => present,
    require => Exec['clone-digcat-tests'],
  }

  exec { 'delay-before':
    command => "/bin/sleep ${delay_before}",
    require => Service['tomcat7'],
  }

  exec { "runtests-cmis":
    cwd => "${alfresco_base_dir}/tests/alfresco-tests/",
    command => "${xvfb} python test_cmis.py",
    path => '/bin:/usr/bin',
    require => [
      File["${alfresco_base_dir}/tests/alfresco-tests/config.yml"],
      Exec["install-cmislib"],
      Service['alfresco-start'],
      Exec['delay-before'],
    ]
  }

  exec { "runtests-ftp":
    cwd => "${alfresco_base_dir}/tests/alfresco-tests/",
    command => "${xvfb} python test_ftp.py",
    path => '/bin:/usr/bin',
    require => [
      File["${alfresco_base_dir}/tests/alfresco-tests/config.yml"],
      Service['alfresco-start'],
      Exec['delay-before'],
    ]
  }

  exec { "runtests-swsdp":
    cwd => "${alfresco_base_dir}/tests/alfresco-tests/",
    command => "${xvfb} python ${testfile}",
    path => '/bin:/usr/bin',
    require => [
      File["${alfresco_base_dir}/tests/alfresco-tests/config.yml"],
      Service['alfresco-start'],
      Exec['delay-before'],
    ]
  }

}
