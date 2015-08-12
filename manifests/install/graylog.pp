class alfresco::install::graylog extends alfresco::install {
  
  class { 'mongodb': } ->
  class { 'elasticsearch': } ->
  class { 'graylog': }
}
