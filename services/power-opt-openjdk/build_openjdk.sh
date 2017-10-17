#!/bin/bash


if [ $# -ne 2 ]; then
    echo "usage: `basename $0` <git-repo> <tag-or-branch>"
    exit 1
fi
apt-get update
apt-get install -y libxext-dev libxrender-dev libxtst-dev libxt-dev libcups2-dev cpio libcups2-dev libfreetype6-dev libasound2-dev

REPO=$1
TAG=$2
WORK_DIR=$PWD/get_openjdk
IMAGE_DIR=$WORK_DIR/build/*/images/j2sdk-image
PACKAGE_NAME=openjdk-image
rm -rf $WORK_DIR
git clone $REPO -b $TAG $WORK_DIR
if [ $? -ne 0 ]; then
    exit 1;
fi

cd $WORK_DIR
bash ./configure
if [ $? -ne 0 ]; then
    exit 1;
fi

make all
if [ $? -ne 0 ]; then
    exit 1;
fi

cp -r $IMAGE_DIR $PACKAGE_NAME
tar zcf ${PACKAGE_NAME}.tar.gz $PACKAGE_NAME
rm -Rf $PACKAGE_NAME
cp /ws/get_openjdk/openjdk-image.tar.gz /ws
echo "Package: ${PACKAGE_NAME}.tar.gz"

exit 0
