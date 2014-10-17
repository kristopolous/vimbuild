#!/bin/bash

. common.sh
INSTALLDIR=~/.vim/

_mkdir $INSTALLDIR
tar xzvf config/dotvim.tar.gz -C $INSTALLDIR

cp config/vimrc ~/.vimrc
