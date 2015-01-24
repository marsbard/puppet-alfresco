class alfresco::aptcache inherits alfresco {

 if $apt_cache_host != '' {

    #Configure apt to use apt-cacher-ng
    class {'apt':
      proxy_host        =>  $apt_cache_host,
      proxy_port        =>  $apt_cache_port,
    }

  }
}
