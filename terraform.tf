provider "aws" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region     = "us-west-2"
}

resource "aws_instance" "example" {
  ami           = "ami-d732f0b7"
  instance_type = "t2.micro"
}
