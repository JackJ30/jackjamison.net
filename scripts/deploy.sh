#!/bin/bash

# grab latest
git pull

# setup nginx
cp ./nginx/homepage.conf /etc/nginx/sites-enabled/homepage.conf

# build and sync zola
(cd zola-static && zola build)
mkdir /var/www/homepage/
rsync -av --delete ./zola-static/public/ /var/www/homepage/

# sync interactive
rsync -av --delete ./interactive/ /var/www/interactive/
