## Order of the Bee "Honeycomb" edition of Alfresco

#### New in 1.1
* ImageMagick paths updated on each run
* Now using Librarian-puppet to manage puppet modules
* Monitoring with monitorix on port 8088
* Support both Mysql & Postgresql as local or remote DB

#### <a name='features'></a>Features
* Standalone build with repo, share, mysql and solr on one server. Remote mysql supported now, remote solr and pentaho next version
* Choose from version 4.2.f, latest 5.0.x or NIGHTLY
* Installation supported on Ubuntu and CentOS. 
* Puppet based, so makes idempotent changes and if interrupted can pick up where it left off
* Simple bash based configuration
* Built in BART backup - run `./setup_backup.sh` after install to configure.
* Reverse proxy and firewall preconfigured, offloading SSL to apache and forwarding real ports (for ftp, for example) to unprivileged ones managed by repo
* Can specify tomcat home and alfresco base, useful for putting `alf_data/` on shared storage
* Built in postfix mail server set up to deliver alfresco mails to the internet
* Supports using your own SSL certificates and if not supplied will generate a self signed certificate
* Custom Order of the Bee theme

#### <a name='included-addons'></a>Included addons
A small list for now but soon to be growing
* Google docs integration
* [Javascript console](https://addons.alfresco.com/addons/javascript-console)
* [Reset password](https://addons.alfresco.com/addons/reset-password-dialog)
* [Alfresco Records Management](https://www.alfresco.com/products/records-management)
* [Uploader Plus](https://addons.alfresco.com/addons/uploader-plus)


#### <a name='getting-started'></a>Getting started

First make sure that `git` is installed on your machine. Now run the following commands:

```
  git clone https://github.com/marsbard/puppet-alfresco.git alfresco
  cd alfresco
  ./install.sh
```

You will see an installer like this (there are a few more parameters in it these days, but it's pretty much the same):

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




#### <a name='backup'></a>Backing up with BART

To configure backup, run this command `sudo ./setup-backup.sh`

You will see a similar configurator to the main one, but this just configures backups.

```
Idx			Param                     Value

[1]			alfresco_base_dir         /opt/alfresco
[2]			backuptype                scp
[3]			backup_at_hour            2
[4]			backup_at_min             23
[5]			duplicity_password        password
[6]			fulldays                  30D
[7]			backup_policies_enabled   true
[8]			clean_time                12M
[9]			maxfull                   6
[10]		volume_size               25
[11]		duplicity_log_verbosity   4
[12]		scp_server                backupserver
[13]		scp_user                  backupuser
[14]		scp_folder                /home/backups

Please choose an index number to edit, A to apply configuration, or Q to quit
 -> 
```
The parameter names you see here mostly match the names in the BART script itself so if you want clarification about anything just check in that file, you'll
find it in `/opt/alfresco/scripts` in the default install, or elsewhere if you changed `alfresco_base_dir`.

Note you should not change `alfresco_base_dir` in this menu since it is picked up automatically from the previous configuration. 

All the backup methods offered by BART are supported, for `backuptype` you can use any of 'scp', 's3', 'local', or 'ftp' and the menu will change to show relevant configuration.


#### <a name='ssl'></a>SSL Configuration

See [this document](docs/ssl.md)


#### <a name='sharepoint'></a>Supporting sharepoint

A note about [sharepoint support](docs/sharepoint.md) - tl;dr? use `https://<domain_name>/spp` as the endpoint in Microsoft Office.


#### <a name='installation-methods'></a>Other installation methods

There were a couple of other installation methods. For historical reasons [they are recorded here](docs/other-install.md)

