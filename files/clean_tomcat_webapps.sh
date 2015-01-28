#!/bin/sh
#-----------------------------------------------------
# script to Clean out application folders from webapps
#only run if no changes have been made to your app 
#inside the webapps folders
#-----------------------------------------------------
sudo rm -rf /opt/alfresco/tomcat/webapps/alfresco
sudo rm -rf /opt/alfresco/tomcat/webapps/share
sudo rm -rf /opt/alfresco/tomcat/webapps/solr4
