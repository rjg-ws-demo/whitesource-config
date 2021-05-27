#!/bin/bash
WSS=/home/ubuntu/ghe/v21.5.1
if (( $# == 1 ))
then
    WSS=$1
fi
echo $WSS

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
echo $DIR
mkdir -p $WSS/conf
cp $DIR/docker-compose.yaml $WSS/docker-compose.yaml
cp $DIR/conf/prop.json $WSS/conf/prop.json
cp $DIR/scanner/Dockerfile $WSS/wss-scanner/docker/Dockerfile
