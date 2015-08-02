#!/bin/bash

TEMPLATE="template/index.html"


function get_all_slides {
  slides_dir="arch java testing"
  for i in $slides_dir; do
    echo $i
  done
}


function get_all_slides_markdown {
  for dir in `get_all_slides`; do
    for i in `find $dir -name '*.md'`; do
      echo $i
    done
  done
}

function process {
  mdfile=$1
  dirname=`dirname $mdfile`
  filename=`basename $mdfile`
  target=$dirname/index.html
  cp -fv $TEMPLATE $target
  sed -i '' "s/\\\$filename\\\$/$filename/" "$target"

  title=`head -1 $mdfile | tr -d '#'`
  if [[ -n $title ]]; then
    sed -i '' "s/\\\$title\\\$/$title/" "$target"
  fi
}

function process_all {
  for i in `get_all_slides_markdown`; do
    process $i
  done
}


process_all
