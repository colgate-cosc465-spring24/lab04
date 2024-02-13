#/bin/bash

if [ $# -ne 1 ]; then
    echo "Usage: ./docker_bind.sh BIND_PORT"
    exit 1
fi

BIND_PORT=$1

docker run --tty --interactive --rm --name=${USER}_bind --cap-add=NET_RAW --cap-add=NET_ADMIN --publish $BIND_PORT:53/tcp --publish $BIND_PORT:53/udp agemberjacobson/cosc465bind:latest
