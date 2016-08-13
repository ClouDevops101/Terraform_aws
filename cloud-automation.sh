#! /bin/bash
# Author: Abdelilah HEDDAR
# A handy shell script that simplify the use of Terraform & ansible 
# #################################################################


# Function
# define usage function
# Verify parameter and trigger usage 
usage(){
	echo "Usage:" 
        echo "     cloud-automation.sh    <app>       <environment> <num_servers> <server_size>"
        echo "ex:  cloud-automation.sh hello_world          dev         2          t1.micro"
        #echo "Recived args : $1 $2 $3 $4"
        exit 1
}

# call usage() function if the 4 parameter not supplied
[[ $# -eq 0 ]] && usage

# Advanced parameter verification
# Number of server
re='^[0-9]+$'
if ! [[ $3 =~ $re ]] ; then
   echo -e "Error: Not a number\n" >&2; usage
fi
# Server Size
re='^.*\..*+$'
if ! [[ $4 =~ $re ]] ; then
   echo -e "Error: Not a valid Server size\n Please refer to https://aws.amazon.com/fr/ec2/instance-types/\n" >&2; usage
fi
#echo "$1 $2 $3 $4"
echo "Starting Terraform"
AWS_ELB_DNS=$(terraform apply  -var "app_name=$1" -var "env_name=$2" -var "num_serv=\"$3\"" -var "serv_size=$4" | grep address | awk -F= '{print $2}' | sed -e 's/\s//g')
echo "Terraform ended $AWS_ELB_DNS"
# sleep waiting for amazon instance 70 second per instance
time_to_zzZZZ=$(( 70  * $3 ))
#sleep $time_to_zzZZZ

echo "Starting Ansible"
#ansible-playbook -i terraform.py -u ubuntu playbook.yml --private-key ~/.ssh/AWSNEWKEY.pem  >/dev/null  2>&1 
echo "Ansible ended"
# Wait for elb IP
echo "waiting for elb"
#elb_dns="abdelilah-heddar-889471894.us-west-2.elb.amazonaws.com"
 while true
  do
   AWS_ELB_DNS_COUNT=$(getent hosts $AWS_ELB_DNS | wc -l)
   echo $AWS_ELB_DNS
   AWS_ELB_IP=$( getent hosts $AWS_ELB_DNS | awk  '{print $1}' )
   echo $AWS_ELB_IP
   if  [ "$AWS_ELB_DNS_COUNT" -eq "0" ]; then
     sleep 4
   elif [ "$AWS_ELB_DNS_COUNT" -eq "1" ]; then
     echo "Application is available url http://$AWS_ELB_IP"
     break
   else
     echo "Sometging wrong"
   fi
 done

