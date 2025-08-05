# A build of Docker container images made to run Magento 2 in a portable, secure and performant way.

## Running

* Install docker-sync [docker-sync.io](http://docker-sync.io?_target=blank)
* run docker-compose build
* run mkdir magento2-webroot 
* run docker-sync-stack-start

## Restarting services after rebuilding an image

* docker-compose stop php
* docker-compose rm php
* docker-compose -f docker-compose.yml -f docker-compose-dev.yml up -d php
