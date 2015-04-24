#!/bin/bash

JAR=$1
ID=$2
ALIASES=$3
VERSION=$4
AMPNAME=$5
TITLE=$6*

cd /tmp
DIR=$$.create-amp.tmp
mkdir $DIR
cd $DIR
mkdir lib
cp $JAR lib
cat > module.properties <<EOF
module.id=$ID
module.aliases=$ALIASES
module.version=$VERSION
module.title=$TITLE
module.description=$TITLE contains $JAR made by jar-to-amp.sh
EOF

zip -r $AMPNAME *

cd ..

rm -rf $DIR
