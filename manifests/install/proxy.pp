class alfresco::install::proxy inherits alfresco {

  # TODO fix indentation

  if $enable_proxy {

  class { 'apache': 
    default_mods => false,
    default_confd_files => false,
		mpm_module => 'prefork',
  }

  file { '/etc/ssl':
    ensure => directory,
  }

  if $ssl_cert_path == '' {
    # we need to generate self signed certs
 
    # http://unix.stackexchange.com/a/104305/100985
    exec { 'one-step-self-sign':
      command => "openssl req -new -newkey rsa:4096 -days 365 -nodes -x509 -subj '/C=US/ST=Denial/L=Springfield/O=Dis/CN=${domain_name}' -keyout /etc/ssl/${domain_name}.key  -out /etc/ssl/${domain_name}.cert",
      path => '/usr/bin',
      require => File['/etc/ssl'],
      creates => "/etc/ssl/${domain_name}.key",
    } ~> Service['httpd']


  } elsif $ssl_cert_path =~ /^http/ {
    # we need to download the certs
    # do it in two stages as the vhost will require a File resource
    # rather than an exec

    exec { "retrieve-key":
      command => "wget ${ssl_cert_path}/${domain_name}.key",
      creates => "${download_path}/${domain_name}.key",
      cwd => $download_path,
      path => '/usr/bin',
      require => File[$download_path],
    } 

    exec { "retrieve-cert":
      command => "wget ${ssl_cert_path}/${domain_name}.cert",
      creates => "${download_path}/${domain_name}.cert",
      cwd => $download_path,
      path => '/usr/bin',
      require => File[$download_path],
    }

    file { "downloaded: /etc/ssl/${domain_name}.cert":
      path => "/etc/ssl/${domain_name}.cert",
      source => "${download_path}/${domain_name}.cert",
      ensure => present,
      require => [
        Exec["retrieve-cert"],
        File['/etc/ssl'],
      ],
    }

    file { "downloaded: /etc/ssl/${domain_name}.key":
      path => "/etc/ssl/${domain_name}.key",
      source => "${download_path}/${domain_name}.key",
      ensure => present,
      require => [
        Exec["retrieve-key"],
        File['/etc/ssl'],
      ],
    }

  } else {
    # the certs are on the filesystem somewhere
    
    file { "/etc/ssl/${domain_name}.key":
      path => "/etc/ssl/${domain_name}.key",
      source => "${ssl_cert_path}/${domain_name}.key",
      ensure => present,
      require => File["/etc/ssl"],
    }

    file { "/etc/ssl/${domain_name}.cert":
      path => "/etc/ssl/${domain_name}.cert",
      source => "${ssl_cert_path}/${domain_name}.cert",
      ensure => present,
      require => File["/etc/ssl"],
    }
  }


  # TODO webdav config here http://serverfault.com/a/472541 

  apache::vhost { $domain_name :
    ssl => true,
    port => 443,
    docroot => "/var/www/${domain_name}", # must have a docroot for puppetlabs apache
    ssl_cert => "/etc/ssl/${domain_name}.cert",
    ssl_key => "/etc/ssl/${domain_name}.key",
    proxy_pass => [
      { 'path' => '/share', 'url' => "ajp://127.0.0.1:8009/share" },
      { 'path' => '/solr4', 'url' => "ajp://127.0.0.1:8009/solr4" },
      { 'path' => '/alfresco', 'url' => "ajp://127.0.0.1:8009/alfresco" },
      { 'path' => '/spp', 'url' => 'http://127.0.0.1:7070/alfresco' },
    ],
		#redirect_source => [ '/', ],
		#edirect_dest => [ '/share', ],
		#redirectmatch_regexp => '^/((?!fileserver).)*$', 
		#redirectmatch_dest => "/share/$1", 
		
  }


	apache::vhost { "${domain_name}_80":
		default_vhost => true,
		ssl => false,
		port => 80,
		docroot => "/var/www/${domain_name}",
		redirect_source => '/', 
		redirect_dest => "https://${domain_name}/", 
		redirect_status => permanent,
	}

  class { 'apache::mod::proxy_ajp': }

  apache::mod { 'rewrite': }

  }
}
