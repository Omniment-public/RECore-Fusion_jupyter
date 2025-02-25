#!/bin/bash
#argv $1:version
RELEASEDIR=recore-jupyter-$1

# check args
if [ $# != 1 ]; then
    echo "need version args"
    exit 1
fi

echo "make release package"

# mkdir release
mkdir $RELEASEDIR

# cp files
cp install.sh ./$RELEASEDIR

# build docker
echo "build docker image"
sudo chmod +x ./build_release.sh
sudo ./build_release.sh $1

echo "move package"
mv ./recore-jupyter-image.tar.gz ./$RELEASEDIR

echo "compress package"
tar -zcvf recore-jupyter-$1.tar.gz $RELEASEDIR

echo "complete release package make"
