#!/bin/bash

if [ -z "$1" ];then
  echo "please add name of comic to position 1 when calling this script"
fi

if [ -d "$DIRECTORY" ]; then
  printf "\nDirectory exists\n$1\n"
  exit 1
fi

mkdir -p Comics/$1/pages
mkdir Comics/$1/images
cp .skel/* Comics/$1/

