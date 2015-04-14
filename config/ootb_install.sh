
source install/inc-puppet.sh

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

