class alfresco::addons::jsconsole inherits alfresco::addons {

  $jsconsolebase = "https://github.com/share-extras/js-console/releases/download/v0.6.0-rc1"

  case($alfresco_version){
      '4.2.f': {
          $jsconsolerepofile = "javascript-console-repo-0.6.0.amp"
          $jsconsolesharefile = "javascript-console-share-0.6.0.amp"
      }
      '5.0.x': {
          $jsconsolerepofile = "javascript-console-repo-0.6.0.amp"
          $jsconsolesharefile = "javascript-console-share-0.6.0.amp"
      }
      '5.1.x': {
          $jsconsolerepofile = "javascript-console-repo-0.6.0.amp"
          $jsconsolesharefile = "javascript-console-share-0.6.0.amp"
      }
      'NIGHTLY': {
          $jsconsolerepofile = "javascript-console-repo-0.6.0.amp"
          $jsconsolesharefile = "javascript-console-share-0.6.0.amp"
      }
  }
  
  $jsconsoleshareurl = "${jsconsolebase}/${jsconsolesharefile}"
  $jsconsolerepourl = "${jsconsolebase}/${jsconsolerepofile}"

  safe_download { 'jsconsole-repo':
    url => $jsconsolerepourl,
    filename => $jsconsolerepofile,
    download_path => "${alfresco_base_dir}/amps",
  }

  safe_download { 'jsconsole-share':
    url => $jsconsoleshareurl,
    filename => $jsconsolesharefile,
    download_path => "${alfresco_base_dir}/amps_share",
  }

}

