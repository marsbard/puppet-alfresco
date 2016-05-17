#!/bin/bash

IMAGEMAGICK=`rpm -ql ImageMagick | grep "/coders" | head -n1`
echo ${IMAGEMAGICK}
IMAGEMAGICK=`sudo find /usr -name jpeg.so  | grep coders | sed "s/\/jpeg.so$//"`
echo ${IMAGEMAGICK}

rm -f /opt/alfresco/ImageMagickCoders
ln -s ${IMAGEMAGICK} /opt/alfresco/ImageMagickCoders
