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

