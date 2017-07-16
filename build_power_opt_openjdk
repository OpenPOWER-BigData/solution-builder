#set -ex
dep_service=power-opt-openjdk
if [ ! -f services/$dep_service/openjdk-image.tar.gz ]; then
   pushd `pwd`
   cd services/$dep_service
   ./build.sh
   popd
fi
