#!/bin/sh -e

TARGET=/usr/local/freeswitch

cd freeswitch
make install
make sounds-install

groupadd freeswitch
adduser --disabled-password  --quiet --system --home $TARGET --ingroup freeswitch freeswitch

rm -rf $TARGET/conf
cp -a ../build/conf $TARGET/conf


rm -rf $TARGET/sounds
mkdir sounds
tar -zxvf freeswitch-sounds-en-us-callie-8000-1.0.51.tar.gz -C sounds
mv sounds $TARGET/sounds


chown -R freeswitch:freeswitch $TARGET
chmod -R ug=rwX,o= $TARGET
chmod -R u=rwx,g=rx $TARGET/bin/*

