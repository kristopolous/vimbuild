#!/bin/bash

. common.sh

echo "Slurping up current vim config"
mkdir -p config

cp ~/.vimrc config/vimrc
cp -r ~/.vim config/
rm -fr config/dotvim
mv config/.vim config/dotvim
_rm config/dotvim/.netrwhist
