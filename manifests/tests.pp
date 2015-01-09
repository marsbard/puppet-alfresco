class alfresco::tests inherits alfresco {

  package { [ 'maven', 'firefox', 'xvfb' ]:
    ensure => latest,
  }

  file { "${alfresco_base_dir}/tests":
    ensure => directory,
  }

  exec { "clone-zaizi-tests":
    command => 'git clone https://github.com/marsbard/alfresco-test-scripts.git',
    cwd => "${alfresco_base_dir}/tests",
    creates => "${alfresco_base_dir}/tests/alfresco-test-scripts/README.md",
    path => '/usr/bin',
  }

  $testbase = "${alfresco_base_dir}/tests/alfresco-test-scripts/ABFT_4_2"
  $confloc = "${testbase}/src/test/resources"

  file { "${confloc}/TestProperties.xml":
    content => template('alfresco/ZaiziTestProperties.xml.erb'),
    ensure => present,
    require => Exec['clone-zaizi-tests'],
  }

  file { "${confloc}/TestValues.xml":
    content => template('alfresco/ZaiziTestValues.xml.erb'),
    ensure => present,
    require => Exec['clone-zaizi-tests'],
  }

  file { "${testbase}/AbftsUploadTest.txt":
    source => 'puppet:///modules/alfresco/ZaiziAbftsUploadTest.txt',
    ensure => present,
    require => Exec['clone-zaizi-tests'],
  }

#  exec { "run-tests":
#    command => "mvn test",
#    cwd => $testbase,
#    path => '/usr/bin',
#    require => [
#      File["${confloc}/TestProperties.xml"],
#      File["${confloc}/TestValues.xml"],
#      File["${testbase}/AbftsUploadTest.txt"],
#    ],
#  }

#  package { 'phantomjs':
#    ensure => latest,
#  }
#
#  $testdir = '/opt/alfresco/tests'
#
#  file { $testdir:
#    ensure => directory,
#  }

#  $tests = [
#    "login.js",
#  ]
#
#  file { $tests: 
#    content => template("alfresco/tests/${name}.erb"),
#    path => "${testdir}/${name}",
#    ensure => present,
#    require => File[$testdir],
#  }
#
#  exec { $tests:
#    require => File[$title],
#    command => "phantomjs ${testdir}/${title}",
#    path => '/bin:/usr/bin',
#  }


#  file { "${testdir}/login.js":
#    ensure => present,
#    content => template('alfresco/tests/login.js.erb'),
#    require => File[$testdir],
#  }
#
#  file { "${testdir}/test.sh":
#    ensure => present,
#    content => template('alfresco/test.sh.erb'),
#    require => File[$testdir],
#    mode => '0755',
#  }

}
