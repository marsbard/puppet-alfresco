class alfresco::install::graylog inherits alfresco::install {
  
  class { 'mongodb': } ->
  class { 'elasticsearch': } ->
  class { 'graylog': }
}
