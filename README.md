# Terraform_aws

A Terraform Ansible config to deply infrastructure on AWS :

```

                                             _____                               
                                            /_____\      
                                           |[^_/\_]|    ________
                                          _|___@@__|__  -------                          
                                          ///     \_\   / /                          
                                         /// HUBOT/\\  //                         
                                         //      /  \\/.     
                                            +---+                            
                                            |   |                            
                                            +===+                            
                                             |xx|  

         [ ] [ ]                       cloud-automation.sh
     __[ ]_[ ]_[ ]__                     |
    |               |                    |
    |  PaaS(Docker) |  <- Ansible -------|
    |_ _____________|                    |
    |               |                    |
    |    IaaS(AWS)  |  <- Terraform------|
    |_______________|

```
## Installation

### Terraform
The easiest way to get the latest binary is 
from hashicorp site:

```bash
$ wget  https://releases.hashicorp.com/terraform/0.7.0/terraform_0.7.0_linux_amd64.zip
$ unzip terraform_0.7.0_linux_amd64.zip 
$ sudo cp -a terraform /usr/local/bin/
$ rm terraform_0.7.0_linux_amd64.zip 
```

### Ansible
If you'd like to build the rpm package yourself then:

```bash
$ sudo yum -y install git asciidoc rpm-build python2-devel
$ sudo rm -rf /usr/lib64/python2.7/site-packages/pycrypto-2.6.1-py2.7.egg-info*
$ sudo yum install  python2-crypto
$ sudo cd /usr/src
$ sudo git clone git://github.com/ansible/ansible.git --recursive
$ sudo cd ansible
$ sudo git checkout stable-2.0.1
$ sudo make rpm
$ sudo yum install rpm-build/ansible-2.2.0-0.git201608111926.925b0ff.devel.el7.centos.noarch.rpm
$ ansible --version
```
### Ansible galaxy 
You may choose the lazy solution like me rather than writing a full ansible docker role 

```bash
$ sudo ansible-galaxy install angstwad.docker_ubuntu 
```
#### The inventory
Since we're deploying a infrastructure we can't guess the ip and basic useful information to establish a connection.$
That's why the Dynamic inventory come in help 
The terraform.py will be executed by ansbile to fetch information from terraform.tfstat file, once terraform is done from creating the platform.

```bash
 chmod +x terraform.py
``` 

