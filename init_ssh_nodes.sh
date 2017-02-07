#!/bin/bash
#set -ex
input=$1

#sudo apt-get install -y sshpass
if [ -z $input ]; then 
   echo "ERROR: missing argument, please add solution defintion file name"
   exit 1
fi

init_ssh() {
  user_name=$1
  ip_address=$2
  password=$3
  sshpass -p $password ssh $user_name@$ip_address "mkdir -p .ssh" < /dev/null
  cat ~/.ssh/id_rsa.pub | sshpass -p $password ssh $user_name@$ip_address "cat >> .ssh/authorized_keys" 
  sshpass -p $password ssh $user_name@$ip_address "chmod 700 .ssh; chmod 640 .ssh/authorized_keys" < /dev/null
  #ssh $user_name@$ip_address ls
}

#stty_orig=`stty -g` # save original terminal setting.
#stty -echo          # turn-off echoing.
#echo -n " Please enter the root password for the cluster: "
IFS= read -s  -p " Please enter the root password for the cluster: " rootPass
printf "\n"
#cho -n " Please enter the user password for the cluster: "
IFS= read -s  -p " Please enter the solution's user password: " userPass
#ead userPass
#stty $stty_orig     # restore terminal setting.
echo "Thanks"

while IFS=',' read -r f1 f2 f3 f4 f5 f6 f7 f8
do 
  ## Ignore lines start with "#"
  case $f1 in
        \#*) continue;;
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

done < "$input"
