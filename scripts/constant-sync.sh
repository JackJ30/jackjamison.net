#!/bin/bash
while true; do
  rsync -av --delete ./zola-static/public/ /var/www/homepage/
  sleep 5  # wait 5 seconds before the next sync
done
