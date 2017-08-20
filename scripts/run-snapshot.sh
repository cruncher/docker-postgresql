#!/bin/sh
. ./setup.sh

if [ -z "$REPLICATION_HOST" ]; then
    echo ""
    echo "You must specify the REPLICATION_HOST environment variable to point the IP address of the master"
    echo "e.g. export REPLICATION_HOST=10.20.30.40"
    echo ""
    exit 1
fi

docker run --name postgresql -itd --restart always \
  --publish 5432:5432 \
  --env-file ./env/common \
  --env-file ./env/snapshot \
  --env REPLICATION_HOST \
  --volume /var/db:/var/lib/postgresql \
  $DOCKER_IMG
