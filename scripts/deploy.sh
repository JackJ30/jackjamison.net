#!/bin/bash

# grab latest
git pull

# setup gninx
cp ./nginx/homepage.conf /etc/nginx/sites-enabled/homepage.conf
mkdir /var/www/homepage/

# build and sync zola
(cd zola-static && zola build)
rsync -av --delete ./zola-static/public/ /var/www/homepage/
