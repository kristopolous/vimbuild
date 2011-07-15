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


pwd_level=0
pwd_start=`pwd`

die () {
  echo $1
  exit 3
}

info() {
  echo "$1"
}

newtemp(){
  # RHEL doesn't have tempfile
  if ( silentfind tempfile ); then
    tempfile=`tempfile`
  else
    tempfile=/tmp/$RANDOM-`date +"%s"`
  fi

  rm $tempfile
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

  CFLAGS='-O3' ./configure\
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
  cp $1 $STARTDIR
  cd $STARTDIR
  extension=${1##*.}

  [ $extension = "bz2" ] && flags=xjf
  [ $extension = "tbz" ] && flags=xjf
  [ $extension = "gz" ] && flags=xzf
  [ $extension = "tgz" ] && flags=xzf

  tar $flags $1

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

installpkg() {
  test=$1
  package=$2
  if ( ! silentfind $test ); then
    $PKGMANAGER install $package > /dev/null 

    if [ $? -ne 0 ]; then
      die "Can't install $package"
    else
      return 0
    fi
  fi
  return 0
}

silentfind () {
  res=`$WHICH $1 2>> $log | wc -c`

  if [ $res -gt 0 ]; then
    return 0
  else
    return 1
  fi
}

Setup () {
  PKGMANAGER=0

  if [ `uname -s` = "Linux" ]; then
    CPUS="-j"`cat /proc/cpuinfo | grep proce | wc -l`
  fi

  if ( silentfind apt-get ); then
    PKGMANAGER="sudo apt-get"
  elif ( silentfind yum ); then
    PKGMANAGER="sudo yum"
  else
    die "Couldn't find a package manager"
  fi

  installpkg cc build-essential
  installpkg ri ri

  if ( ! findpkg libncurses-dev ); then
    $PKGMANAGER install libncurses-dev > /dev/null || die "Can't install ncurses"
  fi
}

Clean () {
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



Download () {
  downloadit vim-$VIM_VERSION.tar.bz2 ftp://ftp.vim.org/pub/vim/unix
}

Build () {
  savepwd $STARTDIR

  if ( ! silentfind ctags ); then
    downloadit ctags-$CTAGS_VERSION.tar.gz
    buildit ctags-$CTAGS_VERSION ctags
  fi

  if ( ! silentfind cscope ); then
    downloadit cscope-$CSCOPE_VERSION.tar.bz2
    buildit cscope-$CSCOPE_VERSION cscope
  fi

  configOpts="--enable-pythoninterp --enable-rubyinterp --with-x --enable-cscope"
  buildit vim73 vim

  restorepwd
}

Install () {
  cd $pwd_start

  newtemp
  info "Backing up .vim to $tempfile"
  mv ~/.vim $tempfile

  newtemp
  info "Backing up .vimrc to $tempfile"
  cp ~/.vimrc $tempfile

  cp -r config/dotvim ~/.vim
  cp config/vimrc ~/.vimrc
}

Setup
Clean
Download
Build
Install
