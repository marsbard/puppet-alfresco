cd `dirname "$0"`

set -e

if [ "$1" = "" ]
then
	echo Please run this command with branch to build as first argument
	exit
fi

export BRANCH=$1

if [ ! -d ./puppet-alfresco ]
then
	git clone http://github.com/marsbard/puppet-alfresco.git -b $BRANCH
fi

cd puppet-alfresco
git checkout $BRANCH
git pull

docker run -ti puppet-alfresco-build 
