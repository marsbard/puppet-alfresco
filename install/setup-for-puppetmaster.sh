
cd "`dirname $0`"/..

if [ -f .IS_VAGRANT ]
then
  echo Sorry, this has been set up for vagrant
fi

if [ -f .IS_STANDALONE ]
then
  echo Sorry, this has been set up for standalone
fi

if [ ! -f .IS_PUPPETMASTER ]
then

  touch .IS_PUPPETMASTER

  git submodule init
  git submodule update

  ./install.sh
fi
