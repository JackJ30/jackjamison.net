#!/bin/bash

cp ./nginx/homepage.conf /etc/nginx/sites-enabled/homepage.conf
mkdir /var/www/homepage/
rsync -av --delete ./zola-static/public/ /var/www/homepage/
