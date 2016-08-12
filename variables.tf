variable "access_key" {}
variable "secret_key" {}
variable "key_name" {
    description = "Name of the SSH keypair to use in AWS."
    default = "AWSNEWKEY"
}
#
#variable "key_path" {
#    description = "Path to the private portion of the SSH key specified."
#}
#variable "aws_region" {
#    description = "AWS region to launch servers."
#    default = "eu-west-1"
#}

# Ubuntu Server 14.04 LTS (x64)
#variable "aws_amis" {
#    default = {
#        eu-west-1 = "ami-5da23a2a"
#    }
#}
