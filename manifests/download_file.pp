# http://projects.puppetlabs.com/projects/1/wiki/Download_File_Recipe_Patterns
define alfresco::download_file(
  $site="",
  $cwd="",
  $creates="",
  $require="",
  $user="") {

  alfresco::safe_download { $name:
    url => "${site}/${name}",
    filename => $name,
    user => $user,
    download_path => $cwd,
  }

}
