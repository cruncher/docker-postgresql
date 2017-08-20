#!/bin/sh
export DOCKER_IMG="cruncher/postgresql:latest"
mkdir -p /var/db
apt-get -qq -y install docker.io
docker pull $DOCKER_IMG

