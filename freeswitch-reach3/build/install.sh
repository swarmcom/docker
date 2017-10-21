#!/bin/sh -e

TARGET=/usr/local/freeswitch

cd freeswitch
make install

groupadd freeswitch
adduser --disabled-password  --quiet --system --home $TARGET --ingroup freeswitch freeswitch

rm -rf $TARGET/conf
cp -a ../build/conf $TARGET/conf

rm -rf $TARGET/sounds
mv ../build/sounds $TARGET/sounds

rm -rf $TARGET/scripts
mv ../build/scripts $TARGET/scripts

chown -R freeswitch:freeswitch $TARGET
chmod -R ug=rwX,o= $TARGET
chmod -R u=rwx,g=rx $TARGET/bin/*
