# Create a new instance of the latest Ubuntu Server on an
# t2.micro node with an AWS Tag naming it "Blog Server 1"
provider "aws" {
  region = "us-west-2"
}

data "aws_ami" "ubuntu_server" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-trusty-14.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}


resource "aws_instance" "web" {
  ami           = "ami-51537029"
  instance_type = "t2.micro"

  tags {
    Name = "Blog Server 1"
  }
}
