#!/bin/bash

#argv $1:version

# check args
if [ $# != 1 ]; then
    echo "need version args"
    exit 1
fi

cd "$(dirname "$0")"

# build
docker build -t recore-jupyter-test:$1 .

docker stop recore-jupyter-test
docker rm recore-jupyter-test

docker run -d --privileged -p8888:8888 -v /dev:/dev -v /run/udev:/run/udev -v /sys/kernel/debug:/sys/kernel/debug  --restart=always --name recore-jupyter-test recore-jupyter-test:$1 jupyter notebook && RUN_STATE=1

#docker run -d --privileged -p8888:8888 -v /dev:/dev -v /home/recore/fusion-files/fusion-notebook:/home/recore/fusion-notebook -v /home/recore/fusion-files/site-package:/home/recore/.local/lib/python3.9/site-packages -v /run/udev:/run/udev  --restart=always --name jupyter recore-jupyter jupyter notebook
