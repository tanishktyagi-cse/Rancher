#!/bin/bash

docker ps | grep rancher/rancher >> temp.txt

DATE=$( date | awk '{ print $2$3$4}' )
RANCHER_CONTAINER_NAME=$( cat temp.txt | awk '{print $1}' )
RANCHER_CONTAINER_TAG="latest"
RANCHER_VERSION="Version-1.0"

rm temp.txt

docker stop $RANCHER_CONTAINER_NAME
sleep 10
docker create --volumes-from $RANCHER_CONTAINER_NAME --name rancher-data-$DATE rancher/rancher:$RANCHER_CONTAINER_TAG
sleep 15
docker run --name busybox-backup-$DATE --volumes-from rancher-data-$DATE -v $PWD:/backup:z busybox tar pzcvf /backup/rancher-data-backup-$RANCHER_VERSION-$DATE.tar.gz /var/lib/rancher
sleep 15
docker start $RANCHER_CONTAINER_NAME
