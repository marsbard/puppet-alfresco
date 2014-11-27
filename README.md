Don't rely on this too much yet but currently it will install Alfresco 4.2.f with a Mysql database on either debian or redhat type systems (tested with Ubuntu 14.04 and CentOS 6.5)

This script is mostly a reimplementation in puppet of Peter Lofgren's work to be found here: https://github.com/loftuxab/alfresco-ubuntu-install

current limitations:

	Username and password are not configurable (currently 'admin')

	mysql root passwd is not set

	thumbnail generation does not work (so presumably other transforms fail too)

	CentOS build does not work right now



To install on a new blank vm or machine, running Ubuntu 12.04 (or later):

	git clone https://github.com/marsbard/puppet-alfresco.git

	<NOT FINISHED, DON'T USE THESE INSTRUCTIONS>
