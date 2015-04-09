
cd "`dirname $0`"/..

DIRS="lib files manifests templates"

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
    for d in $DIRS
    do
      cp -r ${PWD}/${d} ${PWD}/modules/alfresco/${d}
    done
  fi

  # set up a hook to make sure the copied folders are kept up to 
  # date
  cat > .git/hooks/pre-commit <<EOF
for d in $DIRS
do
  rsync -vrz ${PWD}/modules/alfresco/${d} ${PWD}/${d}
done
EOF
  chmod +x .git/hooks/pre-commit

  install/modules-for-vagrant.sh

  ./install.sh
fi
