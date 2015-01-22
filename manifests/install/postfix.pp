class alfresco::install::postfix inherits alfresco {

  if ( $mail_host == 'localhost') {
 
    package { 'postfix':
      ensure => latest,
    }

  } else {

  }

}
