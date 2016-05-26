class alfresco::urls {

  $v50x = '5.0.d'
  $v42x = '4.2.f'

  $nightly = 'http://dev.alfresco.com/downloads/nightly/dist/alfresco-community-distribution-SNAPSHOT-LATEST.zip'
  $nightly_name = 'alfresco-community-distribution'
  $nightly_filename = 'alfresco-community-distribution-SNAPSHOT-LATEST.zip'

  # v4 wars
  $alfresco_ce_filename = 'alfresco-community-4.2.f.zip'
  $alfresco_ce_url = "http://dl.alfresco.com/release/community/4.2.f-build-00012/${alfresco_ce_filename}"
  $alfresco_war_42x = "https://artifacts.alfresco.com/nexus/service/local/repo_groups/public/content/org/alfresco/alfresco/${v42x}/alfresco-${v42x}.war"
  $share_war_42x = "https://artifacts.alfresco.com/nexus/service/local/repo_groups/public/content/org/alfresco/share/${v42x}/share-${v42x}.war"

  $alfresco_war_50x = "https://artifacts.alfresco.com/nexus/service/local/repo_groups/public/content/org/alfresco/alfresco/${v50x}/alfresco-${v50x}.war"
  $share_war_50x = "https://artifacts.alfresco.com/nexus/service/local/repo_groups/public/content/org/alfresco/share/${v50x}/share-${v50x}.war"


  $solr_war_file = "alfresco-solr4-${v50x}-ssl.war"
  $solr_war_dl = "https://artifacts.alfresco.com/nexus/service/local/repo_groups/public/content/org/alfresco/alfresco-solr4/${v50x}/$solr_war_file"
  
  $solr_cfg_file = "alfresco-solr4-${v50x}-config-ssl.zip"
  $solr_cfg_dl = "https://artifacts.alfresco.com/nexus/service/local/repo_groups/public/content/org/alfresco/alfresco-solr4/${v50x}/$solr_cfg_file"


  $spp_v4 = "http://dl.alfresco.com/release/community/4.2.f-build-00012/alfresco-community-spp-4.2.f.zip"
  $spp_v4_zipname = "alfresco-community-spp-4.2.f.zip"
  $spp_v4_name = "alfresco-community-spp-4.2.f.amp"

  $spp_amp_v5 = "https://artifacts.alfresco.com/nexus/service/local/repo_groups/public/content/org/alfresco/alfresco-spp/${v50x}/alfresco-spp-${v50x}.amp"
  $spp_amp_v5_name = "alfresco-spp-${v50x}.amp"


  $loffice_name_deb = 'LibreOffice_4.2.7.2_Linux_x86-64_deb'
  $loffice_dl_deb = "http://downloadarchive.documentfoundation.org/libreoffice/old/4.2.7.2/deb/x86_64/${loffice_name_deb}.tar.gz"

  $loffice_name_red = 'LibreOffice_4.2.7.2_Linux_x86-64_rpm'
  $loffice_dl_red = "http://downloadarchive.documentfoundation.org/libreoffice/old/4.2.7.2/rpm/x86_64/${loffice_name_red}.tar.gz"

  $swftools_src_name = 'swftools-2013-04-09-1007'
  $swftools_src_url = "http://www.swftools.org/${swftools_src_name}.tar.gz"

  $tomcat_version = '7.0.69'
  $name_tomcat = "apache-tomcat-${tomcat-version}"
  $filename_tomcat = "${name_tomcat}.tar.gz"
  $url_tomcat = "http://apache.org/dist/tomcat/tomcat-7/v${tomcat_version}/bin/${filename_tomcat}"

  #$mysql_connector_name = 'mysql-connector-java-5.1.34'
  #$mysql_connector_file = "${mysql_connector_name}.tar.gz"
  #$mysql_connector_url = "http://dev.mysql.com/get/Downloads/Connector-J/${mysql_connector_file}"

  $mysql_connector_version = '5.1.36'
  $mysql_root = "https://repo1.maven.org"
  $mysql_location = "maven2/mysql/mysql-connector-java/${mysql_connector_version}"
  $mysql_connector_name = "mysql-connector-java-${mysql_connector_version}"
  $mysql_connector_file = "${mysql_connector_name}.jar"
  $mysql_connector_url = "${mysql_root}/${mysql_location}/${mysql_connector_file}"
  $mysql_driver = "com.mysql.jdbc.Driver"
  $mysql_params = "?useUnicode=yes&characterEncoding=UTF-8&autoReconnect=true"

  $postgresql_connector_version = "9.4.1208"
  $postgresql_root = "https://jdbc.postgresql.org"
  $postgresql_location = "download"
  $postgresql_connector_name = "postgresql-${postgresql_connector_version}"
  $postgresql_connector_file = "${postgresql_connector_name}.jar"
  $postgresql_connector_url = "${postgresql_root}/${postgresql_location}/${postgresql_connector_file}"
  $postgresql_driver = "org.postgresql.Driver"
  $postgresql_params = ""

  $solr_dl_file = 'alfresco-community-solr-4.2.f.zip'
  $solr_dl = "http://dl.alfresco.com/release/community/4.2.f-build-00012/${solr_dl_file}"

}
