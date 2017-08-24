#!/bin/sh
export DOCKER_IMG="cruncher/postgresql:9.6-2-wale"
mkdir -p /var/db
apt-get -qq -y install docker.io
docker pull $DOCKER_IMG

