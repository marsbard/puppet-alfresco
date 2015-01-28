#!/bin/sh
# ---------------------------------------------------------------
# Script to clean Tomcat temp files and tomcat apps folders
# ---------------------------------------------------------------
echo "Cleaning temporary Alfresco files from Tomcat..."
sudo rm -rf ../tomcat/temp/Alfresco tomcat/work/Catalina/localhost/alfresco
sudo rm -rf ../tomcat/work/Catalina/localhost/share
sudo rm -rf ../tomcat/work/Catalina/localhost/awe
sudo rm -rf ../tomcat/work/Catalina/localhost/wcmqs
sudo rm -rf ../tomcat/webapps/solr4
sudo rm -rf ../tomcat/webapps/share
sudo rm -rf ../tomcat/webapps/alfresco
