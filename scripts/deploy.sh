#!/bin/bash
set -e

# symlink configs
ln -sf $(realpath ./configuration/homepage.conf) /etc/nginx/sites-enabled/homepage.conf
ln -sf $(realpath ./configuration/cgitrc) /etc/cgitrc

# build and sync zola static site
(cd zola-static && zola build)
mkdir -p /var/www/homepage/
rsync -av --delete ./zola-static/public/ /var/www/homepage/

# sync interactive site
rsync -av --delete ./interactive/ /var/www/interactive/
