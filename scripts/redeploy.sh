#!/bin/bash
set -e

# symlink configs
cp ./configuration/nginx/homepage.conf /etc/nginx/sites-enabled/homepage.conf
cp ./configuration/cgit/cgitrc /etc/cgitrc
cp ./configuration/cgit/custom.css /usr/share/cgit/custom.css
cp ./configuration/cgit/head_include.html /usr/share/cgit/head_include.html
install -o git -g git ./configuration/gitolite/gitolite.rc /var/git/.gitolite.rc

# build and sync zola static site
(cd zola-static && zola build)
mkdir -p /var/www/homepage/
rsync -av --delete ./zola-static/public/ /var/www/homepage/

# sync interactive site
rsync -av --delete ./interactive/ /var/www/interactive/
