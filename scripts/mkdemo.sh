#!/bin/bash
#
# mkdemo.sh - setup overlayfs snapshots demo
#

DEMO=/demo
# re-packed zip from http://opengameart.org/sites/default/files/Playing%20Cards.zip
CARDS_TARBALL=~/Downloads/PlayingCards.tgz
CARDS=$DEMO/PlayingCards
MDIRS=$DEMO/1Mdirs
SECRET=Passwords.txt
USER=amir
GROUP=amir
# mkdirs tool from https://github.com/amir73il/fsnotify-utils/tree/master/src/test
MKDIRS=~/bin/mkdirs

setup_demo()
{
	mount $DEMO
	cd $DEMO || exit 1
}

cleanup_cards()
{
	ovlsnapshot umount $CARDS 2>/dev/null
	rm -rf $CARDS
}

setup_cards()
{
	tar xvfz $CARDS_TARBALL
	chown -R $USER:$GROUP $CARDS
}

cleanup_1mdirs()
{
	ovlsnapshot umount $MDIRS 2>/dev/null
	rm -rf $MDIRS/@ $MDIRS/1/2/3/4/* $MDIRS/a/m/i/r/* $MDIRS/1/9/7/3/*
}

setup_1mdirs()
{
	if [ ! -d $MDIRS ]; then
		mkdir $MDIRS
		$MKDIRS $MDIRS 3
	fi
	chown $USER:$GROUP $MDIRS
	echo 12345 > $MDIRS/$SECRET
	chown $USER:$GROUP $MDIRS/$SECRET
}

setup_demo
cleanup_cards
setup_cards
cleanup_1mdirs
setup_1mdirs
