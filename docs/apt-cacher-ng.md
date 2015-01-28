## How to set up apt-cacher-ng to speed up repeated testing

On some Debian or Ubuntu host, install the 'apt-cacher-ng' package.

In your go.pp file, or in your puppetmaster configuration depending on how you are using the module, add the parameter
  
    apt_cache_host => 'server_name_or_ip',

If you have changed the port on which apt-cacher-ng listens you may also use the optional

    apt_cache_port => 1234,

It uses the puppetlabs-apt module, you need to either install it in your puppetmaster:

    puppet module install puppetlabs-apt 

Or if you are using Vagrant, into your local modules folder

    puppet module install puppetlabs-apt --target-dir=modules

It is worth tailing the logs in __/var/log/apt-cacher-ng/__ to make sure that the .deb packages are in fact being requested from there. The configuration for the proxy is in __/etc/apt/apt.conf.d/01proxy__


Note that you also have the option of overriding some of the other large downloads by editing __manifests/urls.pp__ and making the urls point to local copies.

