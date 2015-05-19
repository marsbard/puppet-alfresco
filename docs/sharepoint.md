## Sharepoint support ##

Because we are trying to do an 'all in one' build reverse-proxied through
apache, we cannot map `/alfresco` on the proxy both to the sharepoint 
protocol server on port 7070 as well as the usual `/alfresco` served up 
by tomcat.

Accordingly we have mapped the `http://<domain_name>:7070/alfresco` route 
to `https://<domain_name>/spp`, and it is the latter form which you should 
use from Microsoft Office.

With the latest Office version (2013) you may access the SPP service on 
your alfresco box by typing a URL such as described above into an 'Open'
dialog to browse available files on the server or into a 'Save' dialog to
browse to a save location. You could also use a URL like
`https://<domain_name/spp/swsdp/documentLibrary/test.docx` to target a 
particular file (or folder).
