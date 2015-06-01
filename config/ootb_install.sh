
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

# install external modules
./install/modules-for-vagrant.sh

# ensure that our module is in the right place
if [ ! -d modules/alfresco ]
then
	mkdir modules/alfresco -p
	for d in lib files manifests templates
	do  
		ln -s ${PWD}/${d} ${PWD}/modules/alfresco/${d}
	done
fi  



puppet apply --modulepath=modules go.pp

 if [ $? != 0 ]; then exit 99; fi

echo
echo Completed, please allow some time for alfresco to start
echo You may tail the logs at ${tomcat_home}/logs/catalina.out
echo
echo Note that you can reapply the puppet configuration from this directory with:
echo "	sudo puppet apply --modulepath=modules go.pp"
echo
#echo You can also run the tests with:
#echo "  puppet apply --modulepath=modules test.pp"
#echo

# TODO this should be fixed in bashconf but here for now to expedite
exit
