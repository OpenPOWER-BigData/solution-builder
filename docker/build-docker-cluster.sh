docker ps -aq | xargs docker rm -f
echo $1
img_arch=""
if [ "$HOSTTYPE" = "powerpc64le"  ]; then
   img_arch=_ppc64le
fi
base_image=ynwa/ubuntu_dev
#base_image=ubuntu_dev
docker run -d --privileged -v `pwd`:/bigtop --name master -h master $base_image$img_arch:16.04 bash -l -c "./bigtop/docker/docker_cluster_init.sh; service ssh start;  while true; do sleep 1000; done"
for i in `seq 2 $1`
do 
   docker run -d --privileged -v `pwd`:/bigtop --link master $base_image$img_arch:16.04 bash -l -c "./bigtop/docker/docker_cluster_init.sh;service ssh start;  while true; do sleep 1000; done"
done

