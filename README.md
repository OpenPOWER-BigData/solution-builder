#OpenPOWER Performance Enablement Kit
##A Service Oriented Orchestrator

![Alt text](http://www.scientificcomputing.com/sites/scientificcomputing.com/files/openpower_foundation_ml.jpg)

##### The goal of this project is build a modular and expandable soltuions orchestrator that get a solutions up and running quickly with minimum intervention required in single node, docker nodes, virtual nodes, and multi nodes bare-metal environments. In additional, this project aim is to develop a Solution orachtrator framework that allows for easy repeatability and for sharing of complex, multi-service deployments.

##### Suported Platform:
- Bare metal.
- Docker container
- VMs 
- Ubuntu Linux
- Fedora, Centos, and RHEL - TBD
##### Supported Cluster
- OpenPOWER
- Intel 
- Hybrid (x86 and OpenPower)
- VMs and Docker
- Cloud

##### Sample Solution - Apache Bigtop Orchestrator.
![Alt text](https://cwiki.apache.org/confluence/download/thumbnails/27850921/pb-bigtop.png?version=1&modificationDate=1413827725000&api=v2)
- Java Open JDK 1.8 
- Apache Bigtop  v1.2+ 
  * Hadoop  v2.7.3
  * Spark  v1.6.2 / Spark 2.1
  * Zeppelin  v0.6.2
  * Bigtop-groovy  v2.4.4
  * jsvc  v1.0.15
  * Tomcat  v6.0.36
  * Apache Zookeeper  v3.4.6
- Scala  v2.10.4
- python
- openssl
- snappy
- lzo

##### A Brief Outline of scripts included in this project and their function follows:
-	solution_def - Defines a set of services with a specific configuration and their corresponding connection to other services that can be deployed together in a single step. 
-       deploy_solution.sh - Downloads, installs, configures, and starts all of the servicess defined in the solution definition file.
-	remove_solution.sh - Remove all servicess defined in the solution definition file.
-       start_solution.sh - Start all servicess defined in the solution definition file.
-       stop_solution.sh - Stop all servicess defined in the solution definition file.
-       solution_status.sh - Display status of all servicess defined in the solution definition file.
-	init_ssh_nodes.sh - A utiltiy script to set ssh passwordless connection to all the nodes defined in the solution definition file.

# Lets Start 
### Installer node requirements 
- Any Linux, Windows, OS x system
  * Must have ssh and sshpass installed
  * sshpass for Mac OS x - https://fauxzen.com/installing-sshpass-os-x/   
- OpenPower or x86 architecture 

### Cluster Node prep
- Creating User Account in All Nodes - 
Exmple:
```
sudo useradd myname -U -G sudo -m
sudo passwd myname
```
IMPORTANT - username must match the service's username defined in the solution definition file 
- Mapping the nodes - You have to edit hosts file in /etc/ folder on ALL nodes, specify the IP address of each system followed by their host names. Example
```
# sudo vim /etc/hosts
Append the following lines in the /etc/hosts file.
192.168.1.1 hadoop-master 
192.168.1.2 hadoop-slave-1 
192.168.1.3 hadoop-slave-2
.....
.....
```
