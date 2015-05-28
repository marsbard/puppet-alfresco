
cd "`dirname $0`"/..

if [ -f .IS_VAGRANT ]
then
  echo Sorry, this has been set up for vagrant "(.IS_VAGRANT)"
fi

if [ -f .IS_PUPPETMASTER ]
then
  echo Sorry, this has been set up for puppetmaster "(.IS_PUPPETMASTER)"
fi

if [ ! -f .IS_STANDALONE ]
then

  touch .IS_STANDALONE

  git submodule init
  git submodule update

  if [ ! -d modules -a ! -d modules/alfresco ]
  then
    mkdir modules/alfresco -p
    for d in lib files manifests templates
    do
      ln -s ${PWD}/${d} ${PWD}/modules/alfresco/${d}
    done
  fi


  echo Now run:  sudo ./install.sh

else
	echo Already set up as standalone "(.IS_STANDALONE)"
fi
