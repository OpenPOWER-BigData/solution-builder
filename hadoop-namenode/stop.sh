#!/bin/bash
set -ex

# add additional installation tools for namenode node here
BD_USER=$1
BD_PASSWD=$2
service hadoop-hdfs-namenode stop