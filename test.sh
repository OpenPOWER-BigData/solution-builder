docker ps -aq | xargs docker rm -f

img_arch=""
if [ "$HOSTYPE" = "powerpc64le"  ]; then
   img_arch=_ppc64le
fi
base_image=ynwa/ubuntu_dev
docker run -d --privileged -v `pwd`:/bigtop --name master -h master ynwa/ubuntu_dev$img_arch:16.04 bash -l -c "./bigtop/docker_cluster_init.sh; service ssh start;  while true; do sleep 1000; done"
./init_ssh_nodes.sh solution_def_single_node
./install_services.sh --sd solution_def_single_node --spark-version 1.6.2
