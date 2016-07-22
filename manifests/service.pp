class alfresco::service inherits alfresco {



  service { 'alfresco-start':
    #start => 'JAVA_HOME=/opt/`ls -F /opt | grep jdk | grep /` /etc/init.d/tomcat start',
    #start => 'source /etc/environment && /etc/init.d/tomcat start',
    #start => 'source /etc/profile.d/java.sh && /etc/init.d/tomcat/start',
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
