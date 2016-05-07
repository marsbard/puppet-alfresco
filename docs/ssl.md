## SSL Configuration ##

The `alfresco::install::proxy` module takes an argument `ssl_cert_path` _(which 
is passed to it by `alfresco::init` and can be passed in there)_ 

By default this is expected to be a path on a mounted filesystem, but see below for
information about retrieving the files from an http server.

It expects to find a `.cert` file and a `.key` file named for your domain, so for 
example if your domain is 'demosite.orderofthebee.org' you would arrange for 
your key+cert files to be in the `ssl_cert_path` location and then puppet would try 
to retrieve:

    demosite.orderofthebee.org.key
    demosite.orderofthebee.org.cert

from the `ssl_cert_path` location.

If `ssl_cert_path` starts with "http" then puppet will attempt to download the 
files by appending `/demosite.orderofthebee.org.key` or `/demosite.orderofthebee.org.cert`
as appropriate to `ssl_cert_path`.

If no `ssl_cert_path` is given then new self-signed certificates will be generated

The domain name you use has to match the `domain_name` argument to init.pp

### Important note for Vagrant users ###

If using a filesystem path it must be on the filesystem of the guest. To 
achieve this easily you may make a folder in the same location as your 
Vagrantfile (call it `certs`, or `ssl`, for example) and then refer to it
in the configuration as `/vagrant/certs` or `/vagrant/ssl`
