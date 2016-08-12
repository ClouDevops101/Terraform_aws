provider "aws" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region     = "us-west-2"
}
# Creating instance
resource "aws_instance" "web" {
  count = "${var.num_serv}"
  ami           = "ami-d732f0b7"
  instance_type = "${var.serv_size}"
  key_name = "${var.key_name}"
  security_groups = ["${aws_security_group.default.name}"]
  tags {
        Name = "${var.app_name}"
        Env = "${var.env_name}"
       }
}
# Security group ssh-in & http(s)-in  
resource "aws_security_group" "default" {
    name = "terraform_example"
    description = "Used in the terraform"

    # SSH access from anywhere
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    # HTTP access from anywhere
    ingress {
        from_port = 443
        to_port = 443
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    # HTTP access from anywhere
    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    # outbound internet access
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}
resource "aws_elb" "web" {
  name = "abdelilah.heddar"

  # The same availability zone as our instance
  availability_zones = ["${aws_instance.web.availability_zone}"]

  listener {
    instance_port = 80
    instance_protocol = "http"
    lb_port = 80
    lb_protocol = "http"
  }

  # The instance is registered automatically
  instances = ["${aws_instance.web.*.id}"]
}
