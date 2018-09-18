resource "aws_vpc" "main" {
	cidr_block = "172.31.0.0/16"
	  tags {
		Name = "Main-VPC"
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
  route{
    cidr_block = "0.0.0.0/0"
    instance_id = "${aws_instance.NAT.id}"
  }
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

resource "aws_instance" "NAT" {
  ami           = "ami-40d1f038"
  instance_type = "t2.micro"
  subnet_id = "${aws_subnet.pubsubnet1.id}"
  associate_public_ip_address = true
  vpc_security_group_ids = ["${aws_security_group.NATSG.id}"]
	key_name = "${aws_key_pair.deployer.key_name}"
  tags {
    Name = "NAT Instance"
  }
}

resource "aws_security_group" "BlogSG"{
  name = "BlogSG"
	description = "Blog security group"
	vpc_id = "${aws_vpc.main.id}"
	ingress {
    description = "Allow SSH traffic"
		from_port = 22
		to_port = 22
		protocol = "tcp"
		cidr_blocks = ["0.0.0.0/0"]
	}

}

resource "aws_security_group" "NATSG" {
  name        = "NATSG"
  description = "NAT_security_group"
  vpc_id      = "${aws_vpc.main.id}"
  ingress {
  description = "Allow inbound HTTP traffic from servers in the private subnet"
     from_port   = 80
     to_port     = 80
     protocol    = "tcp"
     cidr_blocks = ["172.31.32.0/19"]
   }

  ingress {
  description = "Allow inbound HTTPS traffic from servers in the private subnet"
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["172.31.32.0/19"]
    }

  ingress {
  description = "Allow inbound SSH access to the NAT instance from your home network (over the Internet gateway)"
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
     }

		 egress {
	   description = "Allow outbound SSH access to the NAT instance from anywhere (over the Internet gateway)"
	       from_port   = 22
	       to_port     = 22
	       protocol    = "tcp"
	       cidr_blocks = ["0.0.0.0/0"]
	      }

  egress {
  description = "Allow outbound HTTP access to the Internet"
     from_port       = 80
     to_port         = 80
     protocol        = "tcp"
     cidr_blocks     = ["0.0.0.0/0"]
   }

  egress {
  description = "Allow outbound HTTPS access to the Internet"
     from_port       = 443
     to_port         = 443
     protocol        = "tcp"
     cidr_blocks     = ["0.0.0.0/0"]
   }
 }

 resource "aws_eip" "lb" {
   instance = "${aws_instance.NAT.id}"
   vpc      = true
 }
