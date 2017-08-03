![Alt](http://www.scientificcomputing.com/sites/scientificcomputing.com/files/openpower_foundation_ml.jpg#right)

OpenPOWER Solution Development Kit
====================================
## Solution Builder - A Service Oriented Orchestrator

### The goal of this project is to build a modular but expandable solution orchestrator engine that deploys a solution quickly with minimum intervention. In addition, this project aim is to develop a framework that allows for easy repeatability and sharing of complex solutions with OpenPOWER community.

### Key Features:
- Deploy a service or collection of services (Solutions) in a distributed fashion
- Configure services
- Manage (i.e. start, stop, status, and remove solution)
- Scale (i.e. add more data nodes)
- Expandable (i.e. add TensorFlow service to a big data cluster) 
- Shareable (i.e domain expert could share services)
- Repeatable (using solution definition and services files)

##### Supported platform:
- Bare metal cluster
- Docker container(s)
- VM(s)
- Hybrid clusters (x86 & Power)

##### Supported Linux Distributions:
- Ubuntu 
- Fedora, Centos, and RHEL 

##### Supported Cluster Types:
- OpenPOWER
- Intel 
- Hybrid (x86 and OpenPower)
- VMs and Docker
- Cloud

##### Installer Platform:
- Any Linux or OS X platform with SSH support

##### A Brief Outline of scripts and files included in this project and their function follows:
- **solution_definition_template** - A Solution Definition file defines a collection of services and their relationships. It is designed to give you an entire working deployment in one easy to use collection. It can be use in two distinct ways. One is to use it locally ( using Docker or KVM cluster) from your computer, which is useful to initially ensure that your solution works and for experimenting. After you are satisfied with the solution definition file, you can push it to github where it will be available to you and others.
- **build_power_opt_openjdk** - A utility file to build optimized openjdk zip file on the installer node - require docker installed. 
- **deploy_solution** - Downloads, installs, configures, and starts all of the servicess defined in the solution definition file.
- **remove_solution** - Remove all servicess defined in the solution definition file.
- **start_solution** - Start all servicess defined in the solution definition file.
- **stop_solution** - Stop all servicess defined in the solution definition file.
- **solution_status** - Display status of all servicess defined in the solution definition file.
- **init_ssh_nodes** - A utiltiy script to set ssh passwordless connection to all the nodes defined in the solution definition file.
- **services** - Conllection of services contributed by the domanin expert.
- **solutions** - Conllection of solutions contributed by the domanin expert.

##### A Sample Solutions 
- Apache Bigtop  v1.2+ 
  * Hadoop  v2.7.3
  * Spark  Spark 2.1
  * Zeppelin  v0.7.2
  * Apache Zookeeper  v3.4.6
  * Optimized OpenJDK 1.8 for Power ( must run **build_power_opt_openjdk** first )
- Scikit-learn
- PowerAI
- PowerAI-Tensorflow node connected to Apache bigtop Cluster (HDFS Sharing)

Pre-requisities
========
### Typical Deployment Flow
![Alt](https://github.com/OpenPOWER-BigData/solution-builder/blob/master/doc/deployment-flow.png)
### Solution Managment Flow
![Alt](https://github.com/OpenPOWER-BigData/solution-builder/blob/master/doc/solution_man.png)

### Getting The Cluster Ready
- Create User Account in All Nodes

Example for Ubuntu:
```
sudo useradd bd_user -U -G sudo -m
sudo passwd bd_user
```
Example for RHEL/Centos/Fedora:
```
sudo useradd bd_user -U -G wheel -m
sudo passwd bd_user
```

-  Set passwordless login

For local host

```
ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa 
cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
chmod 0600 ~/.ssh/authorized_keys
 ```
For other hosts

```
ssh-copy-id -i ~/.ssh/id_rsa.pub user@host
ssh user@host
```

**IMPORTANT - The username must match service's username defined in the solution definition file **
- Ensure the root password is the same on all cluster nodes
- Ensure the username (i.e. bd_user) has the same password on all cluster node.
- Ensure SSH daemon is running on all the nodes.
- Ensure the nodes are set for password-less SSH both ways (master<->slaves).
- It is not necessary to mount the HDDs as the solution-builder can do this. See Installation instructions below.
- Mapping the nodes - You have to edit hosts file in /etc/ folder on ALL nodes, specify the IP address of each system followed by their host names. Example:
```
# sudo vim /etc/hosts
Append the following lines in the /etc/hosts file.
192.168.1.1 hadoop-master 
192.168.1.2 hadoop-slave-1 
192.168.1.3 hadoop-slave-2
.....
.....
```
- RHEL bug workaround - default requiretty field in /etc/sudoers is problematic 
Red Hat has acknowledged the problem nad it will be removed in future releases https://bugzilla.redhat.com/show_bug.cgi?id=1020147
Workaround: Remove below field from /etc/sudoers on all nodes
```
Defaults requiretty
```
### Installation
#### Node Requirements
- Any Linux or OS x system
  * Must have ssh and sshpass installed
  * sshpass for Mac OS x - https://fauxzen.com/installing-sshpass-os-x/
- OpenPower or x86 architecture 
#### Installer Node Setup
- download Solution Builder on your name node
  ```bash
  git clone https://github.com/OpenPOWER-BigData/solution-builder.git 
  
  cd solution-builder
  ```
  
- Use the services/solution_definition_template file to build your own custom solution
- Add/remove services as needed - Please refer to section "Create a New Solution"
- Example of solution definition file for deploying Apache Bigtop 1.2 + optimized OPenJDK 1.8 for Power ( must run **build_power_opt_openjdk** first )
```code
# A Solution Definition File is a collection of services and relationships, designed to
# give you an entire deployment in one easy to use step. Defines the topology of the solution.
# Each line represent a service and is consist of comma-separated fields:
# 1) Service Name
# 2) Space separated list of additional required services to be installed on the same node
# 3) Target node's IP/Hostname
# 4) Service's user name (not root) 
# 5) Configuration and connections values for the service, must be comma-separated.
# Example: Apache Bigtop Deployment
##############################################################################################
# Five nodes Apache Bigtop Deployment
#################### Master node #############################################################
#### Hadoop master node includes namenode, resourcemanager, and spark-master services      ###
#### All Hadoop services have dependency on hadoop-client and optimized openjdk services   ###
#### Next three arguments must be the hostname of the master node                          ###
##############################################################################################
hadoop-namenode,power-opt-openjdk hadoop-client,172.17.0.2,ubuntu,master,master,master
hadoop-resourcemanager,power-opt-openjdk hadoop-client,172.17.0.2,ubuntu,master,master,master
spark-master,power-opt-openjdk hadoop-client,172.17.0.2,ubuntu,master,master,master

#################### Worker Node 1 ###########################################################
#### Includes datanode, nodemanager, and spark worker services                             ###
#### Next three arguments must be the hostname of the master node                          ### 
##############################################################################################
hadoop-datanode,power-opt-openjdk hadoop-client,172.17.0.3,ubuntu,master,master,master
hadoop-nodemanager,power-opt-openjdk hadoop-client,172.17.0.3,ubuntu,master,master,master
spark-worker,power-opt-openjdk hadoop-client,172.17.0.3,ubuntu,master,master,master

#################### Worker Node 2 #############################
hadoop-datanode,power-opt-openjdk hadoop-client,172.17.0.4,ubuntu,master,master,master
hadoop-nodemanager,power-opt-openjdk hadoop-client,172.17.0.4,ubuntu,master,master,master
spark-worker,hadoop-client,172.17.0.4,ubuntu,master,master,master

#################### Worker Node 3 #############################
hadoop-datanode,power-opt-openjdk hadoop-client,172.17.0.5,ubuntu,master,master,master
hadoop-nodemanager,power-opt-openjdk hadoop-client,172.17.0.5,ubuntu,master,master,master
spark-worker,power-opt-openjdk hadoop-client,172.17.0.5,ubuntu,master,master,master

#################### Apache Zeppelin Serivce  #####################
zeppelin,power-opt-openjdk hadoop-client,172.17.0.6,ubuntu,master,master,master

```

## Mount Disks
If you want Hadoop to be install across multiple disks. Make a copy of /services/hadoop-namenode/disk_list.example
```
cd services/hadoop-namenode/
cp disk_list.example disk_list
sudo vim disk_list
```
- Add/remove the appropriate disks according to your cluster setup. (tip: use lsblk in the command console to check the number of physical drives you have)
```
sdb
sdc
sdd
sde
sdf
sdg
sdh
sdi
sdj
sdk
sdl
sdm

```

## Solution Management 
### Deployment
If you are installing for the first time you must deploy the solution.
- deploy_solution --sd <path to solution definition>. Solution level arguments are visible to all install.sh and config.sys scripts
```
./deploy_solution --sd <path to solution definition>
eg.
./deploy_solution --sd solutions/solution_definition_template 
```

### Status of Services
To see which services are currently active
```
./solution_status --sd <path to solution definition>
eg.
./solution_status --sd solutions/solution_definition_template
```
### Test Hadoop/Spark Services
- Test Spark deployment using ssh: **ssh {solution user name}:{namenode IP address} "bash -s" < test/sparkTest.sh**
```
ssh ubuntu@172.17.0.2 "bash -s" < test/sparkTest.sh
```
- Test Hadoop Deployment: **ssh {solution user name}:{namenode IP address} "bash -s" < test/hadoopTest.sh**
```
ssh ubuntu@172.17.0.2 "bash -s" < test/hadoopTest.sh 
```
### Stop Services
```
./stop_solution --sd <path to solution definition>
eg.
./stop_solution --sd solutions/solution_definition_template
```
### Start Services
```
./start_solution --sd <path to solution definition>

./start_solution --sd solutions/solution_definition_template
```
### Restart Services
```
./start_solution --sd <path to solution definition>
eg.
./start_solution --sd solutions/solution_definition_template
```

- For Ubuntu machines, you can use services --status-all to check the status of all your services 
### Remove Solution
Remove the solution and clean up. 
```
./start_solution --sd <path to solution definition>
eg.
./start_solution --sd solutions/solution_definition_template
```

## Addresses & Ports
  
  ```
  HDFS web address : http://localhost:50070
  Spark webUI      : http://localhost:18080 
  Spark History Server : http://localhost:18082
  ```
  
