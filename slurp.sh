#!/bin/bash

echo "Slurping up current vim config"
mkdir -p config

cp ~/.vimrc config/vimrc
cp -r ~/.vim config/dotvim
