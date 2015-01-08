class alfresco::tests inherits alfresco {

  package { 'phantomjs':
    ensure => latest,
  }

  $testdir = '/opt/alfresco/tests'

  file { $testdir:
    ensure => directory,
  }

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


  file { "${testdir}/login.js":
    ensure => present,
    content => template('alfresco/tests/login.js.erb'),
    require => File[$testdir],
  }

  file { "${testdir}/test.sh":
    ensure => present,
    content => template('alfresco/test.sh.erb'),
    require => File[$testdir],
    mode => '0755',
  }

}
