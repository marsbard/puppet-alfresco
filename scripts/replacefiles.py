import os, shutil

def copyFile(src, dest):
    try:
        shutil.copy(src, dest)
    # eg. src and dest are the same file
    except shutil.Error as e:
        print('Error: %s' % e)
    # eg. source or destination doesn't exist
    except IOError as e:
        print('Error: %s' % e.strerror)

sourcefavicon = "/opt/alfresco/tomcat/webapps/share/themes/beeTheme/images/favicon.ico"
replacefavicon = ["/opt/alfresco/tomcat/webapps/ROOT/favicon.ico",
                "/opt/alfresco/tomcat/webapps/alfresco/favicon.ico",
                "/opt/alfresco/tomcat/webapps/alfresco/images/logo/AlfrescoLogo16.ico",
		"/opt/alfresco/tomcat/webapps/share/favicon.ico",
		"/opt/alfresco/tomcat/webapps/solr4/favicon.ico",
		"/opt/alfresco/tomcat/webapps/solr4/img/favicon.ico"]

for favicon in replacefavicon:
	copyFile( sourcefavicon, favicon )
	fd = os.open(favicon,os.O_RDONLY)
	os.fchown( fd, 501, 501)
	os.close(fd)

sourcelogo = "/opt/alfresco/tomcat/webapps/share/themes/beeTheme/images/alfresco-share-logo.png"
replacelogo = ["/opt/alfresco/tomcat/webapps/share/components/images/alfresco-share-logo.png"]

for logo in replacelogo:
        copyFile( sourcelogo, logo )
        fd = os.open(logo,os.O_RDONLY)
        os.fchown( fd, 501, 501)
        os.close(fd)


