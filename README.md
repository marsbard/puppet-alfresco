NOT READY YET

This script is mostly a reimplementation in puppet of Peter Lofgren's work to be found here: https://github.com/loftuxab/alfresco-ubuntu-install

Use it:
* [As a puppet module](#puppetmodule)
* [Standalone installer](#standalone)
* [Run under Vagrant](#vagrant)

Current limitations:

* Username and password are not configurable (currently 'admin')
* mysql root passwd is not set
* thumbnail generation does not work (so presumably other transforms fail too)
* CentOS build does not work right now but support is planned. Only tested on Ubuntu, Debian may work if you're lucky


#### <a name='puppetmodule'></a>Use it as a puppet module
It can be used as a puppet module, for example on your puppet master node 
you can do:

	cd /etc/puppet/modules
	git clone https://github.com/marsbard/puppet-alfresco.git alfresco

to make the module available for use in your puppet scripts.

Here is an example of a minimal puppet script to install alfresco:

	class { 'alfresco':
		domain_name => 'marsbard.com',
	}

And here's a complete example, showing the default values:

	class { 'alfresco':
		domain_name => 'marsbard.com',	
		mail_from_default => 'admin@localhost',	
		alfresco_base_dir => '/opt/alfresco',	
		tomcat_home => '/opt/alfresco/tomcat',	
		alfresco_version => '4.2.f',	
		download_path => '/opt/downloads',	
		db_user => 'alfresco',	
		db_pass => 'alfresco',	
		db_name => 'alfresco',	
		db_host => 'localhost',	
		db_port => '3306',	
	}

The domain name value should be resolvable to the machine we're working on.

Note that currently the only supported value for "alfresco_version" is "4.2.f". 

#### <a name='standalone'></a>Standalone installer
It is also possible to install directly to a machine using a simple bash
installer script (replace "/path/to/base" with the path to a folder on 
the machine):
 
	git clone https://github.com/marsbard/puppet-alfresco.git modules/alfresco
	cp -r modules/alfresco/install* .
	./install.sh


You will see an installer like this:

	    __    __    __    __    __    __    __    __    __    __
	 __/  \__/  \__/  \__/  \__/  \__/  \__/  \__/  \__/  \__/  \__
	/  \__ ORDER OF THE BEE /  \__/  \__/  \__/  \__/  \__/  \__/  \
	\__/  \__/  \__/  \__/  \ Alfresco (TM) Honeycomb Edition   \__/
	   \__/  \__/  \__/  \__/  \__/  \__/  \__/  \__/  \__/  \__/  

	Installer parameters
	--------------------
	Idx	Param                Value

	[1]     domain_name          marsbard.com
	[2]     mail_from_default    admin@localhost
	[3]     alfresco_base_dir    /opt/alfresco
	[4]     tomcat_home          /opt/alfresco/tomcat
	[5]     alfresco_version     4.2.f
	[6]     download_path        /opt/downloads
	[7]     db_user              alfresco
	[8]     db_pass              alfresco
	[9]     db_name              alfresco
	[10]    db_host              localhost
	[11]    db_port              3306

	Please choose an index number to edit, I to install, or Q to quit
	 -> 

If you choose a parameter you will see a short help message, and the current default value will be shown prior to your entry prompt, pressing enter without typing anything will accept the previous value, whether it is a default or a previous answer, as your current answer:

	Please choose an index number to edit, I to install, or Q to quit
	 -> 2
	Parameter: mail_from_default
	Default mail address to use in the 'From' field of sent mails
	[admin@localhost]: 

Edit any parameters you would like to change. If you select "Q" then any parameters you have changed will be saved before quitting, likewise changes are saved before doing the install. Actually selecting the install option will download puppet if necessary and then proceed to apply the puppet configuration to bring the system up to a running alfresco instance.

#### <a name='vagrant'></a>Run under Vagrant

It's useful to run the script under Vagrant sometimes for testing purposes.

To set up a Vagrant environment:

	git clone https://github.com/marsbard/puppet-alfresco.git modules/alfresco
	cp -r modules/alfresco/install* modules/alfresco/Vagrantfile .

You need to run './install.sh' once and quit out of it in order to save the 'go.pp' initial puppet script. 
While in the installer you must set the domain_name parameter and that domain name must be resolvable on the network to the machine you are installing upon. 
(Admittedly this is a bit 'chicken and egg', the best thing is to register the MAC address of the VM with your DHCP server once the VM is running).

	./install.sh
	vagrant up

The network starts as bridged ("public network") and it will ask you which interface you want to bridge to at startup. 

If you need to interrupt provisioning for some reason, when you restart it, "vagrant reload --provision" is probably your best option, it reboots the machine and then restarts provisioning. If you just restart, Vagrant thinks you've done with provisioning.




