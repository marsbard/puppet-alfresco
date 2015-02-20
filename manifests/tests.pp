class alfresco::tests inherits alfresco {

  # this list of tests should match what is checked out of github:
  $tests = [
    'test_imap.py', 'test_cmis.py', 'test_search.py',
    'test_ftp.py', 'test_spp.py', 'test_swsdp.py'
  ]


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

  define runtests (
    $base_dir = ''
  ){ 
		exec { $title:
			command =>  "python ${title}",
      cwd => "${base_dir}/tests",
			path => '/bin:/usr/bin',
		}
  }

  vcsrepo { "${alfresco_base_dir}/tests":
	ensure => latest,
	provider => git,
	source => 'git://github.com/digcat/alfresco-tests.git',
	revision => 'master',
  } ->
  file { "${alfresco_base_dir}/tests/config.yml":
    content => template('alfresco/tests-config.yml.erb'),
    ensure => present,
    require => Vcsrepo["${alfresco_base_dir}/tests"],
  } -> 
  exec { "delay-${delay_before}-before-tests":
    user => 'tomcat7',
    command => "/bin/sleep ${delay_before}",
  } ->
  runtests {  $tests: 
    base_dir => $alfresco_base_dir,
  }



}
