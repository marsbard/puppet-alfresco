
cd "`dirname $0`"/..

if [ -f .IS_STANDALONE ]
then
  echo Sorry, this has been set up for standalone
fi

if [ -f .IS_PUPPETMASTER ]
then
  echo Sorry, this has bene set up for puppetmaster
fi

if [ ! -f .IS_VAGRANT ]
then

  touch .IS_VAGRANT

  git submodule init
  git submodule update

  if [ ! -d modules -a ! -d modules/alfresco ]
  then
    mkdir modules/alfresco -p
    for d in lib files manifests templates
    do
      ln ${PWD}/${d} ${PWD}/modules/alfresco/${d}
    done
  fi

  install/modules-for-vagrant.sh

  ./install.sh
fi
