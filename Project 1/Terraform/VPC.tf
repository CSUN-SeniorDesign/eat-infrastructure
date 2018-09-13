resource "aws_vpc" "main" {
	cidr_block = "172.31.0.0/16"
	  tags {
		Name = "Main-VPC"
	}
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

resource "aws_subnet" "pubsubnet3" {
  vpc_id     = "${aws_vpc.main.id}"
  cidr_block = "172.31.192.0/19"
  availability_zone       = "us-west-2c"
  tags {
    Name = "Pubsubnet3"
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

resource "aws_subnet" "pubsubnet1" {
  vpc_id     = "${aws_vpc.main.id}"
  cidr_block = "172.31.128.0/19"
  availability_zone       = "us-west-2a"
  tags {
    Name = "Pubsubnet1"
	}
}

resource "aws_internet_gateway" "gw" {
  vpc_id = "${aws_vpc.main.id}"
}

resource "aws_instance" "web" {
  ami           = "ami-40d1f038"
  instance_type = "t2.micro"

  tags {
    Name = "NAT Instance"
  }
}

resource "aws_route_table" "public"{
  vpc_id = "${aws_vpc.main.id}"
  
  route{
    cidr_block = "0.0.0.0/0"
	gateway_id = "${aws_internet_gateway.gw.id}"
  }
  
  tags {
		Name = "Public Route Table"
  }
  
}

resource "aws_route_table_association" "pub1" {
  subnet_id      = "${aws_subnet.pubsubnet1.id}"
  route_table_id = "${aws_route_table.public.id}"
}

resource "aws_route_table_association" "pub2" {
  subnet_id      = "${aws_subnet.pubsubnet2.id}"
  route_table_id = "${aws_route_table.public.id}"
}

resource "aws_route_table_association" "pub3" {
  subnet_id      = "${aws_subnet.pubsubnet3.id}"
  route_table_id = "${aws_route_table.public.id}"
}

resource "aws_route_table" "private"{
  vpc_id = "${aws_vpc.main.id}"
	// route[ 
	//Add CIDR block for nat instance here
	// ]
  tags {
		Name = "Private Route Table"
  }
}	

resource "aws_route_table_association" "pri1" {
  subnet_id      = "${aws_subnet.privsubnet1.id}"
  route_table_id = "${aws_route_table.private.id}"
}

resource "aws_route_table_association" "priv2" {
  subnet_id      = "${aws_subnet.privsubnet2.id}"
  route_table_id = "${aws_route_table.private.id}"
}

resource "aws_route_table_association" "priv3" {
  subnet_id      = "${aws_subnet.privsubnet3.id}"
  route_table_id = "${aws_route_table.private.id}"
}

