![Alt text](http://www.scientificcomputing.com/sites/scientificcomputing.com/files/openpower_foundation_ml.jpg)
# OpenPOWER Performance Enablement Kit
# Solution Builder - A Service Oriented Orchestrator
#
#
#
### The goal of this project is build a modular but expandable soltuion orchestrator that get a solution up and running quickly with minimum intervention required in single node, docker nodes, virtual nodes, and multi nodes bare-metal environments. In additional, this project aim is to develop a framework that allows for easy repeatability and for sharing of complex, multi-service deployments.
#
### Key Features:
- Deploy a service or collection of services (Solution) in a distributed fastion 
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
- Ubuntu 
- Fedora, Centos, and RHEL - TBD
##### Supported Cluster
- OpenPOWER
- Intel 
- Hybrid (x86 and OpenPower)
- VMs and Docker
- Cloud


##### A Brief Outline of scripts and files included in this project and their function follows:
-   solution definition file template - A Solution Definition file is a collection of services and their relationships, designed to give you an entire working deployment in one easy to use collection. It can be use in two distinct ways. One is to use it locally ( Docker or VM cluster) from your computer, which is useful to initially ensure that your solution works and for experimenting. After you are satisfied with the solution definition file, you can push it to github where it will be available to you and others.
-   deploy_solution.sh - Downloads, installs, configures, and starts all of the servicess defined in the solution definition file.
-	remove_solution.sh - Remove all servicess defined in the solution definition file.
-   start_solution.sh - Start all servicess defined in the solution definition file.
-   stop_solution.sh - Stop all servicess defined in the solution definition file.
-   solution_status.sh - Display status of all servicess defined in the solution definition file.
-	init_ssh_nodes.sh - A utiltiy script to set ssh passwordless connection to all the nodes defined in the solution definition file.

##### A Sample Solution - Apache Bigtop Orchestrator.
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
#
#
# Lets Start 
### Installer requirements 
- Any Linux, Windows, OS x system
  * Must have ssh and sshpass installed
  * sshpass for Mac OS x - https://fauxzen.com/installing-sshpass-os-x/   
- OpenPower or x86 architecture 

### Cluster prep
- Creating User Account in All Nodes - 
Example:
```
sudo useradd myname -U -G sudo -m
sudo passwd myname
```
IMPORTANT - The username must match service's username defined in the solution definition file 
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
## Solution Prep
### Create a solution Definition File
