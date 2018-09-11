resource "aws_vpc" "main" {
  cidr_block       = "172.31.0.0/16"
  instance_tenancy = "default"

  tags {
    Name = "main"
  }
}

resource "aws_subnet" "privsubnet1" {
  vpc_id     = "${aws_vpc.main.id}"
  cidr_block = "172.31.32.0/19"
  availability_zone       = "us-west-2a"

  tags {
    Name = "Privsubnet1"
  }
}

resource "aws_subnet" "privsubnet2" {
  vpc_id     = "${aws_vpc.main.id}"
  cidr_block = "172.31.64.0/19"
  availability_zone       = "us-west-2b"

  tags {
    Name = "Privsubnet2"
  }
}

resource "aws_subnet" "privsubnet3" {
  vpc_id     = "${aws_vpc.main.id}"
  cidr_block = "172.31.96.0/19"
  availability_zone       = "us-west-2c"

  tags {
    Name = "Privsubnet3"
  }
}

resource "aws_subnet" "pubsubnet1" {
  vpc_id     = "${aws_vpc.main.id}"
  cidr_block = "172.31.128.0/19"
  availability_zone       = "us-west-2a"

  tags {
    Name = "Pubsubnet1"
  }
}

resource "aws_subnet" "pubsubnet2" {
  vpc_id     = "${aws_vpc.main.id}"
  cidr_block = "172.31.160.0/19"
  availability_zone       = "us-west-2b"

  tags {
    Name = "Pubsubnet2"
  }
}

resource "aws_subnet" "pubsubnet3" {
  vpc_id     = "${aws_vpc.main.id}"
  cidr_block = "172.31.192.0/19"
  availability_zone       = "us-west-2c"

  tags {
    Name = "Pubsubnet3"
  }
}
