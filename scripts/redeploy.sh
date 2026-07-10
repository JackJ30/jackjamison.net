#!/bin/bash
set -e

# install configs
cp -v ./configuration/nginx/homepage.conf /etc/nginx/sites-enabled/homepage.conf
cp -v ./configuration/cgit/cgitrc /etc/cgitrc
cp -v ./configuration/cgit/cgit.css /usr/share/cgit/cgit.css
install -v -o git -g git ./configuration/gitolite/gitolite.rc /var/git/.gitolite.rc

# build and sync zola static site
(cd zola-static && zola build)
mkdir -p /var/www/homepage/
rsync -av --delete ./zola-static/public/ /var/www/homepage/

# sync interactive site
rsync -av --delete ./interactive/ /var/www/interactive/
