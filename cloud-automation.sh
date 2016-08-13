#! /bin/bash
# Author: Abdelilah HEDDAR
# A handy shell script that simplify the use of Terraform & ansible 
# #################################################################


# Function
# define usage function
# Verify parameter and trigger usage 
usage(){
	echo "Usage:" 
        echo "      cloud-automation.sh    <app>       <environment> <num_servers> <server_size>"
        echo "/!\   warinig : default value will be applied, this may generate some additional cost "
        echo -e "      cloud-automation.sh \e[5m $App_Name $Env $Num_Serv $Serv_Size \e[0m"
        
}
#Default value
# Arg 1
App_Name="prod"
App_Name=${1:-$App_Name}
# Arg 2
Env="web"
Env=${2:-$Env}
# Arg 3
Num_Serv="1"
Num_Serv=${3:-$Num_Serv}
# Arg 4
Serv_Size="t2.micro"
Serv_Size=${4:-$Serv_Size}

# Advanced parameter verification
# Number of server
re='^[0-9]+$'
if ! [ -z "$3" ]
  then
      if ! [[ $3 =~ $re ]] ; then
      echo -e "/!\ Num_Serv: Not a number"
      echo -e "    Default value will be applied\n" >&2
      Num_Serv="1"
      usage
      fi
fi
# Server Size
re='^.*\..*+$'
if ! [ -z "$4" ]
  then
      if ! [[ $4 =~ $re ]] ; then
      echo -e "/!\ Not a valid Server size default value will be applied"
      echo -e "Please refer to https://aws.amazon.com/fr/ec2/instance-types/\n" >&2
      Serv_Size="t2.micro"
      usage
   fi
fi
# Prvent user from using an applying default value
[[ $# -eq 0 ]] && usage
#echo "$1 $2 $3 $4"
echo "Starting Terraform"
AWS_ELB_DNS=$(terraform apply  -var "app_name=$App_Name" -var "env_name=$Env" -var "num_serv=\"$Num_Serv\"" -var "serv_size=$Serv_Size" | grep address | awk -F= '{print $2}' | sed -e 's/\s//g' | sed -r "s/\x1B\[([0-9]{1,2}(;[0-9]{1,2})?)?[mGK]//g" )
echo "Terraform ended"
# sleep waiting for amazon instance 70 second per instance
time_to_zzZZZ=$(( 70  * $3 ))
sleep $time_to_zzZZZ

# Starting Ansible"
ansible-playbook -i terraform.py -u ubuntu playbook.yml --private-key ~/.ssh/AWSNEWKEY.pem  >/dev/null  2>&1 
# Wait for elb IP
echo "waiting for elb"
 while true
  do
   AWS_ELB_DNS_COUNT=$(dig @8.8.4.4 +short $AWS_ELB_DNS | head -1 | wc -l)
   AWS_ELB_IP=$(dig @8.8.4.4 +short "${AWS_ELB_DNS}" | head -1)
   if  [ "$AWS_ELB_DNS_COUNT" -eq "0" ]; then
     sleep 4
   elif [ "$AWS_ELB_DNS_COUNT" -eq "1" ]; then
     echo "Application is available url http://$AWS_ELB_IP"
     break
   else
     echo "Sometging wrong"
     break
   fi
 done
