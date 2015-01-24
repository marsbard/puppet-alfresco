## How to set up apt-cache-ng to speed up repeated testing

On some Debian or Ubuntu host, install the 'apt-cacher-ng' package.

In your go.pp file, or in your puppetmaster configuration depending on how you are using the module, add the parameter
  
    apt_cache_host => 'server_name_or_ip',

If you have changed the port on which apt-cacher-ng listens you may also use the optional

    apt_cache_port => 1234,



Note that you also have the option of overriding some of the other large downloads by editing manifests/urls.pp and making the urls point to local copies.

