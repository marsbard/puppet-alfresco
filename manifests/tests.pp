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

  exec { 'test login.js':
    require => File["${testdir}/login.js"],
    command => "phantomjs --ignore-ssl-errors=true ${testdir}/login.js",
    path => '/bin:/usr/bin',
    logoutput => always,
  }


	


  # WHEN DONE - delete the tests as they may have admin password in 

  exec { "remove ${testdir}/login.js":
    command => "rm ${testdir}/login.js",
    path => '/bin',
    require => Exec['test login.js'],
  }

}
