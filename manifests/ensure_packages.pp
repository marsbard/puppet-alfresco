define alfresco::ensure_packages ($ensure = "present") {
  if defined(Package[$title]) {}
  else {
    package { $title : ensure => $ensure, }
  }
}

