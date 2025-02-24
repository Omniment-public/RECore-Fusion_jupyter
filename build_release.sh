#!/bin/bash

#argv $1:version

# check args
if [ $# != 1 ]; then
    echo "need version args"
    exit 1
fi

cd "$(dirname "$0")"

# build
docker build -t recore-jupyter:$1 .

echo "export image"
docker save recore-jupyter:$1 -o "recore-jupyter-image.tar"

# compress
echo "compress"
gzip recore-jupyter-image.tar
