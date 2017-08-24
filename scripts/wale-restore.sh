#!/bin/sh
. ./setup.sh

if [ -z "$WALE_RESTORE_POINT" ]; then
    echo ""
    echo "You must specify the WALE_RESTORE_POINT environment variable to restore to a given timeframe"
    echo "e.g. WALE_RESTORE_POINT=LATEST or WALE_RESTORE_POINT='2017-02-01 19:58:55' (UTC!)"
    echo ""
    exit 1
fi

docker stop postgresql && docker rm postgresql

docker run --name postgresql  \
  --publish 5432:5432 \
  --env-file ./env/common \
  --env-file ./env/master \
  --env-file ./env/wal-e \
  --env WALE_RESTORE_POINT \
  --volume /var/db:/var/lib/postgresql \
  --volume /var/tmp:/dump \
  $DOCKER_IMG

echo ""
echo "Ignore grant errors above, simply restart the server with run-master.sh"
echo "Slaves will probably also need to be re-synced: stop them, delete /var/db and restart them."
echo ""
