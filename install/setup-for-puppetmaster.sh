
cd "`dirname $0`"/..

if [ -f .IS_VAGRANT ]
then
  echo Sorry, this has been set up for vagrant. 'rm .IS_VAGRANT' to change. YMMV.
fi

if [ -f .IS_STANDALONE ]
then
  echo Sorry, this has been set up for standalone. 'rm .IS_STANDALONE' to change. YMMV.
fi

if [ ! -f .IS_PUPPETMASTER ]
then

  touch .IS_PUPPETMASTER

  git submodule init
  git submodule update

else
	echo This has previously been set up for puppetmaster. 'rm .IS_PUPPETMASTER' to change. YMMV.
fi
