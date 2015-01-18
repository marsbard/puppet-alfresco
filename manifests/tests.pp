class alfresco::tests inherits alfresco {

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
    command => "git clone https://github.com/marsbard/alfresco-tests.git",
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

  exec { "runtests-cmis":
    cwd => "${alfresco_base_dir}/tests/alfresco-tests/",
    command => "xvfb-run python test_cmis.py",
    path => '/bin:/usr/bin',
    require => [
      File["${alfresco_base_dir}/tests/alfresco-tests/config.yml"],
      Exec["install-cmislib"],
      Service['xvfb'],
    ]
  }

  exec { "runtests-ftp":
    cwd => "${alfresco_base_dir}/tests/alfresco-tests/",
    command => "xvfb-run python test_ftp.py",
    path => '/bin:/usr/bin',
    require => [
      File["${alfresco_base_dir}/tests/alfresco-tests/config.yml"],
      Service['xvfb'],
    ]
  }

  exec { "runtests-swsdp":
    cwd => "${alfresco_base_dir}/tests/alfresco-tests/",
    command => "xvfb-run python test_swsdp.py",
    path => '/bin:/usr/bin',
    require => [
      File["${alfresco_base_dir}/tests/alfresco-tests/config.yml"],
      Service['xvfb'],
    ]
  }

  service { 'xvfb':
    ensure => running,
  }

}
