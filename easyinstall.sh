#!/bin/bash

. common.sh
INSTALLDIR=~/.vim/

backup=`mktemp -d`

echo "Using $mydir as the place"
[ -e $INSTALLDIR ] && mv $INSTALLDIR $backup
mv ~/.vimrc $backup

_mkdir $INSTALLDIR
tar xzvf config/dotvim.tar.gz -C $INSTALLDIR

cp config/vimrc ~/.vimrc
