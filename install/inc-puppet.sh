
function install_puppet {
	echo Installing puppet
	if [ -f /etc/redhat-release ]
	then
		EL_MAJ_VER=`head -n1 /etc/issue | cut -f3 -d\ | cut -f1 -d.`
		rpm -ivh http://yum.puppetlabs.com/puppetlabs-release-el-${EL_MAJ_VER}.noarch.rpm
		yum install -y puppet
	fi

	if [ -f /etc/debian_version ]
	then
		apt-get update
		apt-get install apt-utils -y

    export DEBIAN_FRONTEND=noninteractive
		wget http://apt.puppetlabs.com/puppetlabs-release-trusty.deb
		apt-get install puppet -y

	fi
}
