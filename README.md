This is my custom script to build vim on some random box that I need
to develop from.  It's constantly changing on an as-needed basis.

## Install from source
To install, just run

    ./install.sh

This will download the freshest vim and install it strictly in your `$HOME/bin` directory. Your distribution's vim won't be touched at all. This is a 
non-clobbering pollution free method.  If you want to get to your distributions vim, there's a symlink set up in your `$HOME/bin/` directory to `vim-dist` which
should track back to /usr/bin

## Install just the dot files
orr if you have everything built and you think everything is good.

    ./easyinstall.sh

Screenshots ... everyone loves screen shots

<img src=http://i.imgur.com/0sLBAF3.png>

[acidx](https://github.com/kristopolous/acidx) is also used above.

### some notes

I've been using vim since about 1997. This is my personal configuration and is really only supported on debian systems because that's what I tend to come
in contact with. If you'd like to use it, then great.  Have fun.

