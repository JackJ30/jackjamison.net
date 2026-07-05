#!/bin/bash
set -e

# symlink configs
cp ./configuration/homepage.conf /etc/nginx/sites-enabled/homepage.conf
cp ./configuration/cgitrc /etc/cgitrc
install -o git -g git ./configuration/gitolite.rc /var/git/.gitolite.rc

# build and sync zola static site
(cd zola-static && zola build)
mkdir -p /var/www/homepage/
rsync -av --delete ./zola-static/public/ /var/www/homepage/

# sync interactive site
rsync -av --delete ./interactive/ /var/www/interactive/
