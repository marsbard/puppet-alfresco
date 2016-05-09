define alfresco::safe_download (
  $url,               # complete url to download the file from
  $filename,          # the filename of the download package
  $download_path,     # where to put the file
  $user = 'tomcat',
  $timeout = 0,
) { 
  exec { "safe-clean-any-old-${title}":
    command => "/bin/rm -f ${download_path}/tmp__${filename}",
    creates => "${download_path}/${filename}",
    require => File[$download_path],
    user => $user,
    timeout => $timeout,
  } ->  
  exec { "safe-retrieve-${title}":
    command => "/usr/bin/wget ${url} -O ${download_path}/tmp__${filename}",
    creates => "${download_path}/${filename}",
    user => $user,
    timeout => $timeout,
  } ->
  exec { "safe-move-${title}":
    command => "/bin/mv ${download_path}/tmp__${filename} ${download_path}/${filename}",
    creates => "${download_path}/${filename}",
    user => $user,
    timeout => $timeout,
  }   
}

