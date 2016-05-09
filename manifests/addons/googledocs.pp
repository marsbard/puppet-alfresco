class alfresco::addons::googledocs inherits alfresco::addons {
  case($alfresco_version){
    '4.2.f': {
      $gdrepofile = "alfresco-googledocs-repo-2.0.7-18com.amp"
      $gdrepourl = "http://dl.alfresco.com/release/community/4.2.f-build-00012/${gdrepofile}"
      $gdsharefile = "alfresco-googledocs-share-2.0.7-18com.amp"
      $gdshareurl = "http://dl.alfresco.com/release/community/4.2.f-build-00012/${gdsharefile}"

      # ... and do nothing with them, googledocs no longer compatible with 4.2.f

    }
    '5.0.x','NIGHTLY': {
      $gdrepofile = "alfresco-googledocs-repo-3.0.0.amp"
      $gdrepourl = "https://artifacts.alfresco.com/nexus/service/local/repositories/releases/content/org/alfresco/integrations/alfresco-googledocs-repo/3.0.0/${gdrepofile}"
      $gdsharefile = "alfresco-googledocs-share-3.0.0.amp"
      $gdshareurl = "https://artifacts.alfresco.com/nexus/service/local/repositories/releases/content/org/alfresco/integrations/alfresco-googledocs-share/3.0.0/${gdsharefile}"

      alfresco::safe_download { 'googledocs-repo':
        url => $gdrepourl,
        filename => $gdrepofile,
        download_path => "${alfresco_base_dir}/amps",
      }

      alfresco::safe_download { 'googledocs-share':
        url => $gdshareurl,
        filename => $gdsharefile,
        download_path => "${alfresco_base_dir}/amps_share",
      }


    }



  }



}
