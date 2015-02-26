## marsbard's puppet-alfresco 

![Build status on travis-ci.org](https://api.travis-ci.org/marsbard/puppet-alfresco.svg)

This script is mostly a reimplementation in puppet of Peter Lofgren's work to be found here: https://github.com/loftuxab/alfresco-ubuntu-install

Use it:
* [As a puppet module](#puppetmodule)
* [As a standalone installer](#standalone)
* [Run it under Vagrant](#vagrant)

Current limitations:

* CentOS build has only been tested on 4.2.f where it works apart from thumbnails and previews

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

#### <a name='standalone'></a>Standalone installer
It is also possible to install directly to a machine using a simple bash
installer script. Run the following four commands:
 
	git clone https://github.com/marsbard/puppet-alfresco.git modules/alfresco
	ln -s modules/alfresco/install
	ln -s modules/alfresco/install.sh
	./install.sh


You will see an installer like this:

	    __    __    __    __    __    __    __    __    __    __
	 __/  \__/  \__/  \__/  \__/  \__/  \__/  \__/  \__/  \__/  \__
	/  \__ ORDER OF THE BEE /  \__/  \__/  \__/  \__/  \__/  \__/  \
	\__/  \__/  \__/  \__/  \ Alfresco (TM) Honeycomb Edition   \__/
	   \__/  \__/  \__/  \__/  \__/  \__/  \__/  \__/  \__/  \__/  

	Installer parameters
	--------------------
	Idx     Param                Value

	[1]     domain_name
	[2]     initial_admin_pass   admin
	[3]     mail_from_default    admin@localhost
	[4]     alfresco_base_dir    /opt/alfresco
	[5]     tomcat_home          /opt/alfresco/tomcat
	[6]     alfresco_version     4.2.f
	[7]     download_path        /opt/downloads
	[8]     db_root_password     alfresco
	[9]     db_user              alfresco
	[10]    db_pass              alfresco
	[11]    db_name              alfresco
	[12]    db_host              localhost
	[13]    db_port              3306
	[14]    mem_xmx              32G
	[15]    mem_xxmaxpermsize    256m

	Please choose an index number to edit, I to install, or Q to quit
	 ->

If you choose a parameter you will see a short help message, and the current default value will be shown prior to your entry prompt, pressing enter without typing anything will accept the previous value, whether it is a default or a previous answer, as your current answer:

	Please choose an index number to edit, I to install, or Q to quit
	 -> 2
	Parameter: mail_from_default
	Default mail address to use in the 'From' field of sent mails
	[admin@localhost]: 

Edit any parameters you would like to change. If you select "Q" then any parameters you have changed will be saved before quitting, likewise changes are saved before doing the install. Actually selecting the install option will download puppet if necessary and then proceed to apply the puppet configuration to bring the system up to a running alfresco instance.

If you choose something other than 'localhost' for "db_host" then no mysql server will be installed on the local machine and in this case you must have already created the database on the remote server and configured remote permissions correctly.

#### <a name='vagrant'></a>Run under Vagrant

It's useful to run the script under Vagrant sometimes for testing purposes.

To set up a Vagrant environment:

	git clone https://github.com/marsbard/puppet-alfresco.git modules/alfresco
	ln -s modules/alfresco/install
	ln -s modules/alfresco/install.sh
	ln -s modules/alfresco/Vagrantfile
	./install/modules-for-vagrant.sh

You need to run './install.sh' once and quit out of it in order to save the 'go.pp' initial puppet script. 
While in the installer you must set the domain_name parameter and that domain name should be resolvable on the network to the machine you are installing upon. 
(Admittedly this is a bit 'chicken and egg', the best thing is to register the MAC address of the VM with your DHCP server once the VM is running - to help with this I have included a static MAC address in the network config, otherwise Vagrant/Virtualbox gives you a new MAC address each time which is kind of annoying).

	./install.sh # Choose Q after setting parameters
	vagrant up

It is a good idea to set download_path to be under /vagrant as then you will only need to download Libre Office etc. once, and subsequently after doing "vagrant destroy" they will still be available. Since Libre Office takes a long time to download this is a good idea.

If you choose something other than 'localhost' for "db_host" then no mysql server will be installed on the local machine and in this case you must have already created the database on the remote server and configured remote permissions correctly.

The network starts as bridged ("public network") and it will ask you which interface you want to bridge to at startup. 

If you need to interrupt provisioning for some reason, when you restart it, "vagrant reload --provision" is probably your best option, it reboots the machine and then restarts provisioning. If you just restart, Vagrant thinks you've done with provisioning.




