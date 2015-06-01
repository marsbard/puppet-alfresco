
## Other install methods ##

This is here for historical reasons, the main build method now is just the standalone.

#### <a name='puppetmodule'></a>Use it as a puppet module

If you do not have a puppetmaster server, please ignore this section and check out [the standalone installer](#standalone)

It can also be used as a puppet module, for example if you have a puppet master 
you can do:

```
	cd /etc/puppet/modules
	git clone https://github.com/marsbard/puppet-alfresco.git alfresco
	cd alfresco
	install/setup-for-puppetmaster.sh
```

to make the module available for use in your puppet scripts.

Here is an example of a minimal puppet script to install alfresco:

	class { 'alfresco':
		domain_name => 'marsbard.com',
	}

The domain_name value should be resolvable to the machine we're working on.

Here's a more complete example, showing the default values (domain_name has no default). See the output of install.sh (go.pp) for the latest configuration:

	class { 'alfresco':
		domain_name => 'marsbard.com',	
		mail_from_default => 'admin@localhost',	
		alfresco_base_dir => '/opt/alfresco',	
		tomcat_home => '/opt/alfresco/tomcat',	
		alfresco_version => '4.2.f',	
		download_path => '/opt/downloads',	
		db_root_password => 'alfresco',
		db_user => 'alfresco',	
		db_pass => 'alfresco',	
		db_name => 'alfresco',	
		db_host => 'localhost',	
		db_port => '3306',	
	}


Note that currently the only supported values for "alfresco_version" are "4.2.f",  "5.0.x", and "NIGHTLY".

If you choose something other than 'localhost' for "db_host" then no mysql server will be installed on the local machine and in this case you must have already created the database on the remote server and configured remote permissions correctly.

#### <a name='vagrant'></a>Run under Vagrant

It's useful to run the script under Vagrant sometimes for testing purposes.

To set up a Vagrant environment:

```
	git clone https://github.com/marsbard/puppet-alfresco.git alfresco
	cd alfresco
	install/setup-for-vagrant.sh
```

You need to run './install.sh' once and quit out of it in order to save the 'go.pp' initial puppet script. 
While in the installer you must set the domain_name parameter and that domain name should be resolvable on the network to the machine you are installing upon. 
(Admittedly this is a bit 'chicken and egg', the best thing is to register the MAC address of the VM with your DHCP server once the VM is running - to help with this I have included a static MAC address in the network config, otherwise Vagrant/Virtualbox gives you a new MAC address each time which is kind of annoying).

	./install.sh # Choose Q after setting parameters
	vagrant up

It is a good idea to set download_path to be under /vagrant as then you will only need to download Libre Office etc. once, and subsequently after doing "vagrant destroy" they will still be available. Since Libre Office takes a long time to download this is a good idea.

If you choose something other than 'localhost' for "db_host" then no mysql server will be installed on the local machine and in this case you must have already created the database on the remote server and configured remote permissions correctly.

The network starts as bridged ("public network") and it will ask you which interface you want to bridge to at startup. 

If you need to interrupt provisioning for some reason, when you restart it, "vagrant reload --provision" is probably your best option, it reboots the machine and then restarts provisioning. If you just restart, Vagrant thinks you've done with provisioning.
