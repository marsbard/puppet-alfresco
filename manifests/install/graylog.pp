class alfresco::install::graylog inherits alfresco::install {

  file { "/etc/apt/apt.conf.d/99auth":       
    owner     => root,
    group     => root,
    content   => "APT::Get::AllowUnauthenticated yes;",
    mode      => 644;
  } ->
  apt::source { 'elastic':
    location => 'http://packages.elasticsearch.org/elasticsearch/1.4/debian',
    release => 'stable',
    repos => 'main',
    include => { 'deb' => true },
  } ->
  class { 'elasticsearch': } ->
  class { 'mongodb': } ->
  class { 'graylog2': }

}
