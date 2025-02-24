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
mkdir $RELEASEDIR/recore-jupyter

# cp files
cp install.sh ./$RELEASEDIR
cp install_sys.sh ./$RELEASEDIR
cp -r raspberry-pi ./$RELEASEDIR
cp ./recore-jupyter/install.sh ./$RELEASEDIR/recore-jupyter

# build docker
echo "build docker image"
sudo chmod +x ./recore-jupyter/build_release.sh
sudo ./recore-jupyter/build_release.sh $1

echo "move package"
mv ./recore-jupyter/recore-jupyter-image.tar.gz ./$RELEASEDIR/recore-jupyter

echo "compress package"
tar -zcvf recore-jupyter-$1.tar.gz $RELEASEDIR

echo "complete release package make"
