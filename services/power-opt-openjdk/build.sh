rm build_openjdk.sh openjdk-image.tar.gz
wget https://raw.githubusercontent.com/OpenPOWER-BigData/build-opt-openjdk/master/build_openjdk.sh
chmod +x build_openjdk.sh
sudo docker run --rm -v `pwd`:/ws bigtop/slaves:trunk-ubuntu-16.04-ppc64le bash -l -c "cd /ws; ./build_openjdk.sh https://github.com/mtbrandy/openjdk-jdk8u.git jdk8u152-b03-opt; rm -rf get_openjdk"
