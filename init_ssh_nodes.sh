#!/bin/bash
#set -ex

while [ ! -z $2 ]; do
    case "$1" in
        --sd ) solution_def_file=$2 ;;
        * ) usage ;;
    esac
    shift
done
echo "solution definition file="$solution_def_file

init_ssh() {
  user_name=$1
  ip_address=$2
  password=$3
  sshpass -p $password ssh $user_name@$ip_address "mkdir -p .ssh" < /dev/null
  cat ~/.ssh/id_rsa.pub | sshpass -p $password ssh $user_name@$ip_address "cat >> .ssh/authorized_keys" 
  sshpass -p $password ssh $user_name@$ip_address "chmod 700 .ssh; chmod 640 .ssh/authorized_keys" < /dev/null
}

IFS= read -s  -p " Please enter the root password for the cluster: " rootPass
printf "\n"
IFS= read -s  -p " Please enter the solution's user password: " userPass

echo "Thanks"

while IFS=',' read -r f1 f2 f3 f4 f5 f6 f7 f8
do 
  ## Ignore lines start with "#"
  case $f1 in
        \#*) continue;;
        "") continue;;
  esac
  echo "Service Name="$f1
  echo "  Service Location="$f3
  echo "  Service User Name="$f4
  init_ssh root $f3 $rootPass
  ssh -q root@$f3 exit < /dev/null
  echo "testing ssh connection to IP root@$f3 ... result=$?"
  init_ssh $f4 $f3 $userPass
  ssh -q $f4@$f3 exit < /dev/null
  echo "testing ssh connection to IP $f4@$f3 ... result=$?"

done < "$solution_def_file"
