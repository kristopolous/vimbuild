#!/bin/bash
#
# vimbuild
# 
#  A bash script that builds a custom version of vim and installs
#  a variety of plugins.
#
#  This is an unversioned, often-changing array of stuff.
#
#  You can find the latest here: https://github.com/kristopolous/vimbuild
#
log=/dev/stderr
VIM_VERSION=7.4.768
VIM_DIREXPAND=74
CSCOPE_VERSION=15.8a
CTAGS_VERSION=5.8
BINDIR=~/bin
LIBDIR=~/lib
STARTDIR=`pwd`/temp
DOWNLOADDIR=$STARTDIR/_distfiles_
HAS_FAILED=0

# avoid the builtin shell which
WHICH=/usr/bin/which

pwd_start=`pwd`

_mkdir () {
  while [ $# -gt 0 ]; do
    if [ ! -d "$1" ]; then 
      [ -e "$1" ] && rm -f "$1"
      mkdir -p "$1"
    fi
    shift
  done
}

_rm () {
  [ -e "$1" ] && rm "$1"
}

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

_hg() {
  hg $*
  if [ $? -ne "0" ]; then
    echo "Last command failed. Exiting.";
    exit 1
  fi
}

_sudo () {
  if [ `whoami` = 'root' ]; then
    $*
  elif ( gotpermission "$*" ); then
    sudo $*
  fi
}

install_jsctags () {
  (
    cd $STARTDIR
    git clone https://github.com/mozilla/doctorjs.git

    # from https://github.com/mozilla/doctorjs/issues/55#issuecomment-25028455
    cd doctorjs 
    git submodule update --init --recursive

    # from https://github.com/mozilla/doctorjs/issues/52#issuecomment-48830845
    sed -i '51i tags: [],' ./lib/jsctags/ctags/index.js
    _sudo make install
  )
}

buildit () {
  cd $STARTDIR/$1

  make distclean

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

  ln /usr/bin/vim $BINDIR/vim-dist

  make $CPUS
  replaceit $2
  make install
}

gotpermission () {
  echo "Script wants permission for: $1"
  echo -n "Do you grant this? [ Y / (N) ] "
  read permission
  [ $permission == 'y' -o $permission == 'Y' ]
  return $?
}

downloadit () {
  (
    cd $DOWNLOADDIR

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

  )
}

replaceit () {
  [ -e $BINDIR/$1 ] && mv $BINDIR/$1 $BINDIR/$1.old
  mv $1 $BINDIR/
  chmod 0755 $BINDIR/$1
}

_findpkg () {
  $PKGSEARCH $1 > /dev/null 
  return $?
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
  package=$1
  $PKGMANAGER install $package > /dev/null 

  if [ $? -ne 0 ]; then
    die "Can't install $package"
  else
    return 0
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

InstallIfNeeded() {
  while [ $# -gt 0 ]; do
    if ! _findpkg $1; then
      info "installing $1"
      installpkg $1
    fi
    shift
  done
}

Setup () {
  PKGMANAGER=0
  PKGSEARCH=0

  if [ `uname -s` = "Linux" ]; then
    CPUS="-j"`cat /proc/cpuinfo | grep proce | wc -l`
  fi

  if silentfind apt-get; then
    PKGMANAGER="_sudo apt-get -y"
    PKGSEARCH="dpkg-query -W"
  elif silentfind yum; then
    PKGMANAGER="_sudo yum"
    PKGSEARCH="yum search"
  else
    die "Couldn't find a package manager"
  fi

  InstallIfNeeded libncurses5-dev build-essential #mercurial
}

Clean () {
  _mkdir $BINDIR $LIBDIR

  if [ -d $STARTDIR ]; then
    cd $STARTDIR
    rm -fr [A-Z0-9a-z]*
  fi
  _mkdir $STARTDIR $DOWNLOADDIR

  cd $STARTDIR
}

Download () {
  cd $STARTDIR
  downloadit vim-$VIM_VERSION.tar.bz2 #ftp://ftp.vim.org/pub/vim/unix
  return 0

  if [ -e vim ]; then
    cd vim
    _hg pull
    _hg update
  else
    _hg clone https://vim.googlecode.com/hg/ vim
  fi
}

Build () {
  cd $STARTDIR

#  if ( ! silentfind ctags ); then
#    downloadit ctags-$CTAGS_VERSION.tar.gz
#    buildit ctags-$CTAGS_VERSION ctags
#  fi
#
#  if ( ! silentfind cscope ); then
#    downloadit cscope-$CSCOPE_VERSION.tar.gz
#    buildit cscope-$CSCOPE_VERSION cscope
#  fi

  configOpts="--enable-pythoninterp --enable-rubyinterp --with-x --enable-cscope"
  buildit vim74 vim
}

Install () {
  cd $pwd_start

  if [ -e ~/.vim ]; then
    newtemp
    info "Backing up .vim to $tempfile"
    mv ~/.vim $tempfile
  fi

  if [ -e ~/.vimrc ]; then
    newtemp
    info "Backing up .vimrc to $tempfile"
    cp ~/.vimrc $tempfile
  fi

#  if ( silentfind npm ); then
#    if ( gotpermission "install mozilla's doctorjs for javscript ctags" ); then
#      install_jsctags
#    fi
#  fi

  cp -r config/dotvim ~/.vim
  cp config/vimrc ~/.vimrc
}

Finish () {
  echo "Finished! Remember:"
  echo
  echo "  ** Add $BINDIR to your path. **"
  echo
}

