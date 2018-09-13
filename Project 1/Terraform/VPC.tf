provider "aws" {
  region = "us-west-2"
}

data "aws_ami" "AmazonLinuxNAT" {
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
  ami           = "ami-40d1f038"
  instance_type = "t2.micro"

  tags {
    Name = "NAT Instance"
  }
}