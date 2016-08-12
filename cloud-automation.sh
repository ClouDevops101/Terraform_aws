#! /bin/bash
# A shell that simplify the use of Terraform & ansible 
# 
# Function
# define usage function
# Verify parameter and trigger usage 
usage(){
	echo "Usage:" 
        echo "     cloud-automation.sh    <app>       <environment> <num_servers> <server_size>"
        echo "ex:  cloud-automation.sh hello_world          dev         2          t1.micro"
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
echo "$1 $2 $3 $4"

# Get a fresb teraform version from GitHub
#git clone https://github.com/LinuxArchitects/Terraform_aws.git

terraform plan  -var "app_name=$1" -var "env_name=$2" -var "num_serv=\"$3\"" -var "serv_size=$4"
#ansible-playbook -i terraform.py -u ubuntu playbook.yml --private-key ~/.ssh/AWSNEWKEY.pem
