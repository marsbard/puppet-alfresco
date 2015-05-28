
cd "`dirname $0`"/..

DIRS="lib files manifests templates"

if [ -f .IS_STANDALONE ]
then
  echo Sorry, this has been set up for standalone. "(.IS_STANDALONE)"
fi

if [ -f .IS_PUPPETMASTER ]
then
  echo Sorry, this has bene set up for puppetmaster "(.IS_PUPPETMASTER)"
fi

if [ ! -f .IS_VAGRANT ]
then

  hash puppet 2>/dev/null || { echo >&2 "I require puppet but it's not installed.  Aborting."; exit 1; }

  git submodule init
  git submodule update

  if [ ! -d modules -a ! -d modules/alfresco ]
  then
    mkdir modules/alfresco -p
    for d in $DIRS
    do
      ln -s ${PWD}/${d} ${PWD}/modules/alfresco/${d}
    done
  fi

  ## set up a hook to make sure the copied folders are kept up to 
  ## date
#  cat > .git/hooks/pre-commit <<EOF
#for d in $DIRS
#do
#  rsync -vrz ${PWD}/modules/alfresco/${d} ${PWD}/${d}
#done
#EOF
#  chmod +x .git/hooks/pre-commit

  install/modules-for-vagrant.sh 
	if [ $? != 0 ] 
	then
		echo Error in modules-for-vagrant
		exit 1
	fi

  echo Now run: sudo ./install.sh
  touch .IS_VAGRANT
else
	echo Already set up as vagrant "(.IS_VAGRANT)"
fi
