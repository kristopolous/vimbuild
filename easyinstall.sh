#!/bin/bash

cd 
curl https://raw.github.com/kristopolous/vimbuild/master/config/dotvim.tar.gz | tar xzvf - -C ~/.vim/
curl https://raw.github.com/kristopolous/vimbuild/master/config/vimrc > .vimrc