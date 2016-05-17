#!/bin/bash

IMAGEMAGICK=`sudo find /usr -name jpeg.so  | grep coders | sed "s/\/jpeg.so$//"`
echo ${IMAGEMAGICK}
DESTLINK="/opt/alfresco/ImageMagickCoders"

if test -e "/opt/alfresco/ImageMagickCoders"; then
   ln -sfn ${IMAGEMAGICK} ${DESTLINK} 
else
   ln -s ${IMAGEMAGICK} ${DESTLINK} 
fi;
