
function install_puppet {
  OS=`head -n1 /etc/issue | cut -f1 -d\ `
	echo Installing puppet
	if [ "$OS" == "CentOS" -o "$OS" == "RedHat" ]
	then
		EL_MAJ_VER=`head -n1 /etc/issue | cut -f3 -d\ | cut -f1 -d.`
		rpm -ivh http://yum.puppetlabs.com/puppetlabs-release-el-${EL_MAJ_VER}.noarch.rpm
		yum install -y puppet
	fi

	if [ "$OS" == "Debian" -o "$OS" == "Ubuntu" ]
	then
		apt-get update
		apt-get install apt-utils -y

    export DEBIAN_FRONTEND=noninteractive
		wget http://apt.puppetlabs.com/puppetlabs-release-trusty.deb
		apt-get install puppet -y

	fi
}


ERR=$?
if [ $ERR != 0 ]
then
	return 1
fi

if [ "`which puppet`" = "" ]
then
	install_puppet
fi

 ./install/modules-for-vagrant.sh

puppet apply --modulepath=modules go.pp

 if [ $? != 0 ]; then exit 99; fi

echo
echo Completed, please allow some time for alfresco to start
echo You may tail the logs at ${tomcat_home}/logs/catalina.out
echo
echo Note that you can reapply the puppet configuration from this directory with:
echo "	puppet apply --modulepath=modules go.pp"
echo
echo You can also run the tests with:
echo "  puppet apply --modulepath=modules test.pp"
echo

