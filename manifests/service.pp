class alfresco::service inherits alfresco {


  service { 'alfresco-start':
    name => 'tomcat',
    ensure => running,
    enable => true,
    subscribe => [
      File["${tomcat_home}/shared/classes/alfresco-global.properties"],
      Exec["unpack-alfresco-war"],
      Exec["unpack-share-war"],
    ],
  }

}
