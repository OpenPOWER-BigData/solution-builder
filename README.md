
![Alt text](http://www.scientificcomputing.com/sites/scientificcomputing.com/files/openpower_foundation_ml.jpg)
# OpenPOWER Performance Enablement Kit
# Solution Builder - A Service Oriented Orchestrator
#
#
#
### The goal of this project is build a modular but expandable solution orchestrator that get a solution up and running quickly with minimum intervention required in single node, docker nodes, virtual nodes, and multi nodes bare-metal environments. In additional, this project aim is to develop a framework that allows for easy repeatability and for sharing of complex, multi-service deployments.
#
### Key Features:
- Deploy a service or collection of services (Solution) in a distributed fashion 
- Configure
- Manage
- Scale
- Expandable
- Shareable - i.e Application-specific knowledge
- Repeatable
- 
-
##### Suported Nodes:
- Bare metal.
- Docker container
- VM 
=======
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

Copy authorized_keys to each node

- Allow login as root ssh (necessary in some scenarios)



Enabling the root account:
```
sudo -i
```
To enable the Root account (i.e. set a password) use:
```
sudo passwd root
```
Allow root login
```
sudo vi /etc/ssh/sshd_config

change line to PermitRootLogin yes
```
Restart ssh service
```
sudo service sshd restart
```
It is recommended to disable this again after installation

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
## Solution Prep
### Create a solution Definition File

Quick Deployment

1. Cluster Basic Requirement
 
Hardware and Software Requirement

a) You need 1 Management or Installer node from which you install and run all jobs
Example: spoc8cxeond.aus.stglabs.ibm.com running redhat 7

b) You also need 1 Master node and 1 or more datanodes. Example on a 4 nodes cluster, you need 5 total nodes.
— Installer node can be running  Ubuntu or Redhat.

c)  Install ubuntu 16.04 on all cluster nodes, and setup private network.
— Create local DNS for your private network  in /etc/hosts
— Add the cluster NODES and installer node’s private ip address to each server in  /etc/hosts

Example of Entries in /etc/hosts

10.10.2.10 wlkmaster
10.10.2.11 wlk1
10.10.2.12 wlk2
10.10.2.13 wlk3
 10.10.2.9 clustermgmt

IMPORTANT:  all nodes must be in the same subnet and private network as in the /etc/hosts entries above

Set Hostname

—Login to each cluster nodes and set the hostname appropriately
example to set the masternode hostname to wlkmaster: 

$ sudo set hostname wlkmaster      

d) Install sshpass

1.1 Identify Hard Disks to format  
!Warning! Identify the hard drives available for use for this Spark cluster. Be sure the disks selected do not include the operating system boot disk or any other disk you want to preserve. This operation will reformat the disks selected and erase all data. This has to be done on each node of the cluster.
 
The following lines describe, for your information, the process of discovering the disks to use by running lsblk.
You may need the help of your system administrator to select the disk you want to be part of the hdfs file system of the cluster. Be sure the list does not include the operating system boot disk or any disk you want to preserve.

a) Please run this task on the masternode and each of the datanodes.

As in this example
$ sudo  lsblk
NAME   MAJ:MIN RM   SIZE RO TYPE MOUNTPOINT
sda      8:0    1 931.5G  0 disk 
├─sda1   8:1    1     7M  0 part 
├─sda2   8:2    1 893.8G  0 part /
└─sda3   8:3    1  37.7G  0 part [SWAP]
sdb      8:16   1 931.5G  0 disk 
sdc      8:32   1   5.5T  0 disk 
sdd      8:48   1   5.5T  0 disk 
sde      8:64   1   5.5T  0 disk 
sdf      8:80   1   5.5T  0 disk 
sdg      8:96   1   5.5T  0 disk 
sdh      8:112  1   5.5T  0 disk 
sdi      8:128  1   5.5T  0 disk 
sdj      8:144  1   5.5T  0 disk 
sdk      8:160  1   5.5T  0 disk 
sdl      8:176  1   5.5T  0 disk 
sdm      8:192  1   5.5T  0 disk 
sr0     11:0    1  1024M  0 rom  
sr1     11:1    1  1024M  0 rom  
sr2     11:2    1  1024M  0 rom  
sr3     11:3    1  1024M  0 rom  
 
In the example above: sda is being used for the OS, so it cannot be used. For example all the 5.5T disks [ sdc .... sdm] are good candidates in this case. It is suggested to use disks of the same size.

b) build the disk_list file using the format below

sd[your_firs_disk_id]
sd[your_second_disk_id]
sd[Your_third_disk_id]
….

c) cp the disk_file to each subdirectory under solution_builder
Example:
$ cp disk_file to ./solution_builder/common

d) Install sshpass

$ sudo apt-get install sshpass

 2. Building the cluster

a) login to the installer or management node , create a user to manage the cluster. 
—Exit and log back in with the cluster management user.

b) download the package

$ git clone https://github.com/OpenPOWER-BigData/solution-builder.git 
$ cd solution-builder
—use the solution_def template file to build your own custom input file  using the fields below:

#Service Name, required service, target node IP address, Username_to_RunService, namenode hostname, resourcemanager hostname, spark-master hostname

— create a USER on each cluster node to run services
$ init_ssh_nodes.sh Your_Solution_Def_File

$ ./deploy_solution.sh --sd <solution definition file name> --spark-version <spark version>

    where:
        <spark version> is one of ["1.6.2", "2.1"]

3. Test cluster functionality

a)Testing Hadoop

$ ssh Cluster_username@wlkmaster "bash -s" < common/hadoopTest.sh 

b) Testing Spark
$ ssh Cluster_username@wlkmaster "bash -s" < common/hadoopTest.sh 

——End of installation———

4. Optional: To uninstall and Reinstall Apache BigTop

a) login to the management or installer node with the cluster management user

$ cd ./solution-builder
$ ./remove_solution.sh —sd  <solution definition file name>
$ $ ./deploy_solution.sh --sd <solution definition file name> --spark-version <spark version>



=======
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
