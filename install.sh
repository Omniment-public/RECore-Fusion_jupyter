#!/bin/bash
#RECore Fusion jupter install

APP_NAME="recore-jupyter"
DIPS_NAME="Jupyter Notebook"
IMG_NAME="recore-jupyter-image.tar.gz"
REPO_INFO="Omniment-public/RECore-Fusion_jupyter"
VERSION="v0.0.0"
APP_LINK="location.host:8888"

SYS_DIR="/usr/local/bin/recore/files"
INSTALL_FILES="/usr/local/bin/recore/install/"$APP_NAME
APP_DIR="/home/recore/fusion-files/"$APP_NAME
REGIST_DIR=$SYS_DIR"/app"

INFO_DIR=$APP_DIR"/.info"
REPO_INFO_FILE=$INFO_DIR"/repo_info"
VERSION_FILE=$INFO_DIR"/version"

mkdir $APP_DIR
mkdir $APP_DIR/.info

# check root
if [ ! "$(id -u)" = 0 ]; then
	echo "Please run root user"
	exit 1
fi

# make dir
mkdir $APP_DIR/fusion-notebook
mkdir $APP_DIR/site-package
chmod 777 $APP_DIR/*
chmod 777 $INFO_DIR

# stop and remove old container
docker rm -f recore-jupyter

# load new image
docker load -i $INSTALL_FILES/$IMG_NAME

RUN_STATE=0
docker run -d --privileged -p8888:8888 -v /dev:/dev -v $APP_DIR/fusion-notebook:/home/recore/fusion-notebook -v $APP_DIR/site-package:/home/recore/.local/lib/python3.9/site-packages --name recore-jupyter recore-jupyter:$VERSION jupyter notebook && RUN_STATE=1

if [ $RUN_STATE = 1 ];then
	docker image prune -f | grep "recore-jupyter"
	# write repo info
	sudo bash -c "echo $REPO_INFO > $REPO_INFO_FILE"
	sudo bash -c "echo $VERSION > $VERSION_FILE"

	# regist system
	sudo bash -c "echo 'display_name=\"'$VERSION'\"' > $REGIST_DIR/$APP_NAME"
	sudo bash -c "echo 'app_link=\"'$APP_LINK'\"' >> $REGIST_DIR/$APP_NAME"
	sudo bash -c "echo 'version=\"'$VERSION'\"' >> $REGIST_DIR/$APP_NAME"
	sudo bash -c "echo 'repo=\"'$REPO_INFO'\"' >> $REGIST_DIR/$APP_NAME"
	sudo bash -c "echo 'dir=\"'$APP_DIR'\"' >> $REGIST_DIR/$APP_NAME"
else
	docker run -d --privileged -p8888:8888 -v /dev:/dev -v $APP_DIR/fusion-notebook:/home/recore/fusion-notebook -v $APP_DIR/site-package:/home/recore/.local/lib/python3.9/site-packages --name recore-jupyter recore-jupyter jupyter notebook && RUN_STATE=1
fi

# docker run -d --privileged -p8888:8888 -v /dev:/dev -v /home/recore/fusion-files/fusion-notebook:/home/recore/fusion-notebook -v /home/recore/fusion-files/jupyter-venv:/home/recore/jupyter-venv --restart=always --name jupyter jupyter-recore bash -c ". /home/recore/jupyter-venv/bin/activate && jupyter notebook"
