#!/bin/bash


function install_puppet {
        echo Installing puppet
        apt-get update
        apt-get install apt-utils -y

        export DEBIAN_FRONTEND=noninteractive
        wget http://apt.puppetlabs.com/puppetlabs-release-precise.deb
        apt-get install puppet -y
}


apt-get update
apt-get install git

install_puppet

MODS="puppetlabs-stdlib puppetlabs-mysql"
for MOD in $MODS
do
	puppet module install --force $MOD --target-dir modules
done


mkdir /opt/alfresco
cd /opt/alfresco

git clone https://github.com/marsbard/puppet-alfresco.git modules/alfresco

echo > go.pp <<EOF

class { 'alfresco':
        domain_name => 'jenkins',
        mem_xmx => '2G',
        mem_xxmaxpermsize => '256m',
}
EOF

#puppet apply --modulepath=modules go.pp

