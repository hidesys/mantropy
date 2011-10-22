#!/bin/sh
if 'pwd' = "/var/www/dev/mantropy/" -a $1
then
  git add .
  git commit -m $1
  git pull
  git push
  cd /var/www/mantropy/
  git checkout go_on
  git merge master
  touch tmp/restart.txt
  cd /var/www/dev/mantropy/
fi
