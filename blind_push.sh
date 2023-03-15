#!/usr/bin/env bash

if [ "$1" = "" ]
then
  echo "Usage: $0 <commit message>"
  exit
fi

git add -A
git commit -m "$1"
git push

# npm run deploy