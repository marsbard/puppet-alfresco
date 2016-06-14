cd `dirname "$0"`

set -e

if [ "$1" = "" ]
then
	echo Please run this command with branch to build as first argument
	exit
fi

export BRANCH=$1
rm -rf puppet-alfresco
git clone https://github.com/marsbard/puppet-alfresco.git -b $BRANCH

docker build -t puppet-alfresco-build .
pwd
docker run -ti puppet-alfresco-build 
