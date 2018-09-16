resource "aws_security_group" "NAT_SG_Rules" {
  name        = "NATSG"
  description = "NAT_security_group"
  vpc_id      = "vpc-0b273ffb040f22319"

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
      cidr_blocks = ["172.31.128.0/19"]
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
