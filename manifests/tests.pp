class alfresco::tests inherits alfresco {

  $packages = [ 
    'python',
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

  exec { "install cmislib":
    command => "easy_install cmislib",
    path => "/usr/bin",
# TODO - find out what this creates and put it here:
    # creates => "/usr/lib/cmislib???",
    require => Package['python'],
  }

  python::pip { 'configure':
    owner => 'root',
    pkgname => 'configure',
    require => Package['python'],
  }

  python::pip { 'configuration':
    owner => 'root',
    pkgname => 'configuration',
    require => Package['python'],
  }

  python::pip { 'selenium':
    owner => 'root',
    pkgname => 'selenium',
    require => Package['python'],
  }

  exec { "clone-digcat-tests":
    command => "git clone https://github.com/digcat/alfresco-tests.git",
    path => "/usr/bin",
    cwd => "${alfresco_base_dir}/tests",
    require => File["${alfresco_base_dir}/tests"],
  }

  file { "${alfresco_base_dir}/tests":
    ensure => directory,
  }

  file { "${alfresco_base_dir}/tests/alfresco-tests/config.yml":
    content => template('alfresco/tests-config.yml.erb'),
    ensure => present,
    require => Exec['clone-digcat-tests'],
  }

}
