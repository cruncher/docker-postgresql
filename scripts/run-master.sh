#!/bin/sh
. ./setup.sh

docker run --name postgresql -itd --restart always \
  --publish 5432:5432 \
  --env-file ./env/common \
  --env-file ./env/master \
  --env-file ./env/wal-e \
  --volume /var/db:/var/lib/postgresql \
  --volume /var/tmp:/dump \
  $DOCKER_IMG
