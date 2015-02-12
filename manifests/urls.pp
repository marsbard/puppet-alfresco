class urls {

  $nightly = 'http://dev.alfresco.com/downloads/nightly/dist/alfresco-community-5.1-SNAPSHOT.zip'
  $nightly_name = 'alfresco-community-5.1-SNAPSHOT.zip'



  # v4 wars
	$alfresco_ce_filename = 'alfresco-community-4.2.f.zip'
	$alfresco_ce_url = "http://dl.alfresco.com/release/community/4.2.f-build-00012/${alfresco_ce_filename}"


  # v5 wars
  #$alfresco_war_50x = 'http://tinyserver/alf5/alfresco-5.0.c.war'
  #$share_war_50x = 'http://tinyserver/alf5/share-5.0.c.war'


  $alfresco_war_50x = 'https://artifacts.alfresco.com/nexus/service/local/repo_groups/public/content/org/alfresco/alfresco/5.0.c/alfresco-5.0.c.war'
  $share_war_50x = 'https://artifacts.alfresco.com/nexus/service/local/repo_groups/public/content/org/alfresco/share/5.0.c/share-5.0.c.war'


	$solr_war_file = "alfresco-solr4-5.0.c-ssl.war"
	$solr_war_dl = "https://artifacts.alfresco.com/nexus/service/local/repo_groups/public/content/org/alfresco/alfresco-solr4/5.0.c/$solr_war_file"
	
	$solr_cfg_file = "alfresco-solr4-5.0.c-config-ssl.zip"
	$solr_cfg_dl = "https://artifacts.alfresco.com/nexus/service/local/repo_groups/public/content/org/alfresco/alfresco-solr4/5.0.c/$solr_cfg_file"


  $spp_v4 = "http://dl.alfresco.com/release/community/4.2.f-build-00012/alfresco-community-spp-4.2.f.zip"
  $spp_v4_zipname = "alfresco-community-spp-4.2.f.zip"
  $spp_v4_name = "alfresco-community-spp-4.2.f.amp"


  $spp_amp_v5 = "https://artifacts.alfresco.com/nexus/service/local/repo_groups/public/content/org/alfresco/alfresco-spp/5.0.c/alfresco-spp-5.0.c.amp"
  $spp_amp_v5_name = "alfresco-spp-5.0.c.amp"


	$loffice_name_deb = 'LibreOffice_4.2.7.2_Linux_x86-64_deb'
  $loffice_dl_deb = "http://downloadarchive.documentfoundation.org/libreoffice/old/4.2.7.2/deb/x86_64/${loffice_name_deb}.tar.gz"

	$loffice_name_red = 'LibreOffice_4.2.7.2_Linux_x86-64_rpm'
	$loffice_dl_red = "http://downloadarchive.documentfoundation.org/libreoffice/old/4.2.7.2/rpm/x86_64/${loffice_name_red}.tar.gz"




	$swftools_src_name = 'swftools-2013-04-09-1007'
	$swftools_src_url = "http://www.swftools.org/${swftools_src_name}.tar.gz"


	$name_tomcat = 'apache-tomcat-7.0.55'
  $filename_tomcat = "${name_tomcat}.tar.gz"
  $url_tomcat = "http://archive.apache.org/dist/tomcat/tomcat-7/v7.0.55/bin/${filename_tomcat}"


	$mysql_connector_name = 'mysql-connector-java-5.1.34'
  $mysql_connector_file = "${mysql_connector_name}.tar.gz"
  $mysql_connector_url = "http://dev.mysql.com/get/Downloads/Connector-J/${mysql_connector_file}"



  $solr_dl_file = 'alfresco-community-solr-4.2.f.zip'
  $solr_dl = "http://dl.alfresco.com/release/community/4.2.f-build-00012/${solr_dl_file}"



}
