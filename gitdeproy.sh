#!/bin/sh
if 'pwd' = "/var/www/dev/mantropy/" -a $1
then
  cd /var/www/mantropy
  git add .
  git rm --cached Gemfile.lock
  git commit -m $1
  cd /var/www/mantropy
  git pull
  touch tmp/restart.txt
  cd /var/www/devmantropy/
fi
