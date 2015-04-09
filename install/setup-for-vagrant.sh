
cd "`dirname $0`"/..
touch .IS_VAGRANT

if [ ! -d modules -a ! -d modules/alfresco ]
then
  mkdir modules/alfresco -p
  mv lib files manifests templates modules/alfresco
fi

install/modules-for-vagrant.sh
