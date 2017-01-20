#!/bin/bash

BD_USER=$1
BD_PASSWD=$2
service hadoop-yarn-resourcemanager  restart
#service hadoop-mapreduce-historyserver restart
