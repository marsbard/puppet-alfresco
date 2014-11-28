NOT READY YET

This script is mostly a reimplementation in puppet of Peter Lofgren's work to be found here: https://github.com/loftuxab/alfresco-ubuntu-install

Use it:
* [As a puppet module](#puppetmodule)
* [Standalone installer](#standalone)

Current limitations:

	Username and password are not configurable (currently 'admin')

	mysql root passwd is not set

	thumbnail generation does not work (so presumably other transforms fail too)

	CentOS build does not work right now but it is planned to be fixed


#### <a name='puppetmodule'></a>Use it as a puppet module
It can be used as a puppet module, for example on your puppet master node 
you can do:

	cd /etc/puppet/modules
	git clone https://github.com/marsbard/puppet-alfresco.git alfresco

to make the module available for use in your puppet scripts.


#### <a name='standalone'></a>Standalone installer
It is also possible to install directly to a machine using a simple bash
installer script (replace "/path/to/base" with the path to a folder on 
the machine):
 
	mkdir -p /path/to/base 
	cd /path/to/base
	git clone https://github.com/marsbard/puppet-alfresco.git modules/alfresco
	mv modules/alfresco/install* .
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

If you choose a parameter you will see a short help message, and the current default value will be shown prior to your entry prompt:

	Please choose an index number to edit, I to install, or Q to quit
	 -> 2
	Parameter: mail_from_default
	Default mail address to use in the 'From' field of sent mails
	[admin@localhost]: 

Edit any parameters you would like to change. If you select "Q" then any parameters you have changed will be saved before quitting, likewise changes are saved before doing the install. Actually selecting the install option will download puppet if necessary and then proceed to apply the puppet configuration to bring the system up to a running alfresco instance.
