
cd "`dirname $0`"/..

if [ -f .IS_VAGRANT ]
then
  echo Sorry, this has been set up for vagrant
fi

if [ -f .IS_PUPPETMASTER ]
then
  echo Sorry, this has been set up for puppetmaster
fi

if [ ! -f .IS_STANDALONE ]
then

  touch .IS_STANDALONE

  git submodule init
  git submodule update

  if [ ! -d modules -a ! -d modules/alfresco ]
  then
    mkdir modules/alfresco -p
    mv lib files manifests templates modules/alfresco
  fi


  ./install.sh
fi
