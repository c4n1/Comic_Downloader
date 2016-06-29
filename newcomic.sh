#!/bin/bash

if [ -z "$1" ];then
  echo "please add name of comic to position 1 when calling this script"
fi

if [ -d "Comics/$1" ]; then
  printf "Directory exists exiting : Comics/$1\n"
  exit 1
fi

mkdir -p Comics/$1/pages
mkdir Comics/$1/images
cp .skel/* Comics/$1/

