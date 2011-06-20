#!/bin/sh

log=/dev/stderr
VIM_VERSION=7.3
CSCOPE_VERSION=15.7a
CTAGS_VERSION=5.8
BINDIR=~/bin
LIBDIR=~/lib
STARTDIR=`pwd`/temp
DOWNLOADDIR=$STARTDIR/_distfiles_
ARRAY=$BINDIR/array

# avoid the builtin shell which
WHICH=/usr/bin/which

if [ `uname -s` = "Linux" ]; then
  CPUS="-j"`cat /proc/cpuinfo | grep proce | wc -l`
fi

pwd_level=0

die () {
  echo $1
  exit 3
}

savepwd () {
  $ARRAY build_pwd $pwd_level `pwd`
  cd $1
  pwd_level=$((pwd_level + 1))
}

restorepwd () {
  pwd_level=$((pwd_level - 1))
  cd `$ARRAY build_pwd $pwd_level`
}

buildit () {
  savepwd $STARTDIR/$1

  ./configure\
    --bindir=$BINDIR\
    --sbindir=$BINDIR\
    --libexecdir=$LIBDIR\
    --datadir=$LIBDIR\
    --sysconfdir=$LIBDIR\
    --sharedstatedir=$LIBDIR\
    --localstatedir=$LIBDIR\
    --libdir=$LIBDIR\
    --infodir=/tmp\
    --mandir=/tmp\
    $configOpts

  make $CPUS
  replace $2
  make install

  restorepwd
}

downloadit () {
  savepwd $DOWNLOADDIR

  if [ ! -e $1 ]; then
    if [ $# -gt "1" ]; then
      wget $2/$1
    else
      wget ftp://ftp.netbsd.org/pub/pkgsrc/distfiles/$1
    fi
  fi

  restorepwd
}

replaceit () {
  [ -e $BINDIR/$1 ] && mv $BINDIR/$1 $BINDIR/$1.old
  mv $1 $BINDIR/
  chmod 0755 $BINDIR/$1
}

findpkg () {
  n=`dpkg -l $1 | wc -l`

  if [ $n -ne 0 ]; then 
    return 0
  else
    return 1
  fi
}

_00_Setup () {
  PKGMANAGER=0

  if ( silentfind apt-get ); then
    PKGMANAGER="sudo apt-get"
  elif ( silentfind yum ); then
    PKGMANAGER="sudo yum"
  else
    die "Couldn't find a package manager"
  fi

  if ( ! silentfind cc ); then
    $PKGMANAGER install build-essential > /dev/null || die "Can't install gcc"
  fi

  if ( ! findpkg libncurses-dev ); then
    $PKGMANAGER install libncurses-dev > /dev/null || die "Can't install ncurses"
  fi
}

_01_Clean () {
  [ -d $BINDIR ] || mkdir -p $BINDIR
  [ -d $LIBDIR ] || mkdir -p $LIBDIR

  if [ -d $STARTDIR ]; then
    cd $STARTDIR
    rm -fr [A-Z0-9a-z]*
  else
    mkdir $STARTDIR
  fi

  [ -d $DOWNLOADDIR ] || mkdir $DOWNLOADDIR


  if [ ! -e $ARRAY ]; then
    cd $DOWNLOADDIR
    file=array-latest.tbz
    if [ ! -e $file ]; then
      wget https://github.com/downloads/kristopolous/array/$file || die "Couldn't get array-latest.tbz, sorry"
    fi
    cp $file $STARTDIR
    cd $STARTDIR
    tar xjf $file
    cd array
    make array
    cp array $BINDIR
  fi

  cd $STARTDIR
}

_02_Download () {
  downloadit vim-$VIM_VERSION.tar.bz2 ftp://ftp.vim.org/pub/vim/unix

#  getit .vimrc
#  getit dot_vim.tgz
}

_03_Extract () {
  savepwd $DOWNLOADDIR

  cp * $STARTDIR
  cd $STARTDIR

  ls *.bz2 | xargs -L 1 tar xjf 
  ls *.gz | xargs -L 1 tar xzf 

  restorepwd
}

silentfind () {
  res=`$WHICH $1 2>> $log | wc -c`

  if [ $res -gt 0 ]; then
    return 0
  else
    return 1
  fi
}

_04_Build () {
  savepwd $STARTDIR

  if ( ! silentfind ctags ); then
    downloadit ctags-$CTAGS_VERSION.tar.gz
    buildit ctags-$CTAGS_VERSION ctags
  fi

  if ( ! silentfind cscope ); then
    downloadit cscope-$CSCOPE_VERSION.tar.bz2
    buildit cscope-$CSCOPE_VERSION cscope
  fi

  configOpts="--enable-rubyinterp --with-x --enable-cscope"
  buildit vim73 vim

  restorepwd
}

_05_Install () {
  savepwd $STARTDIR
  tar xzf vimgdb/vimgdb_runtime.tgz -C ~/.vim
  restorepwd

  savepwd ~
  tar xzf dot_vim.tgz
  rm dot_vim.tgz
  restorepwd
}

_00_Setup
_01_Clean
_02_Download
_03_Extract
_04_Build
_05_Install
