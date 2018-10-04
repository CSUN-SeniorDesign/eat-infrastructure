resource "aws_lb" "Load-Balancer"{
  name               = "Load-Balancer"
  internal           = false
  load_balancer_type = "application"
  security_groups = ["${aws_security_group.NATSG.id}"]
  enable_cross_zone_load_balancing = true
  enable_deletion_protection = false

  subnets            = ["${aws_subnet.pubsubnet1.id}","${aws_subnet.pubsubnet2.id}","${aws_subnet.pubsubnet3.id}"]
}

resource "aws_alb_listener" "HTTP-Listener"{
	load_balancer_arn = "${aws_lb.Load-Balancer.id}"
	port = 80
	default_action {
		type = "redirect"
    redirect {
      port = "443"
      protocol = "HTTPS"
      status_code = "HTTP_301"
    }
	}
}

resource "aws_alb_listener" "HTTPS-Listener"{
	load_balancer_arn = "${aws_lb.Load-Balancer.id}"
	port = "443"
  protocol = "HTTPS"
	ssl_policy = "ELBSecurityPolicy-2016-08"
	certificate_arn = "${aws_acm_certificate.cert.arn}"
	default_action {
		type = "forward"
		target_group_arn = "${aws_alb_target_group.HTTP-Group.arn}"
	}
}

resource "aws_alb_target_group" "HTTP-Group" {
  name     = "HTTP-Group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = "${aws_vpc.main.id}"
}

resource "aws_alb_target_group_attachment" "HTTP-attachment-1" {
  target_group_arn = "${aws_alb_target_group.HTTP-Group.arn}"
  target_id        = "${aws_instance.web.id}"
  port             = 80
}

resource "aws_alb_target_group_attachment" "HTTP-attachment-2" {
  target_group_arn = "${aws_alb_target_group.HTTP-Group.arn}"
  target_id        = "${aws_instance.web2.id}"
  port             = 80

}


resource "aws_acm_certificate" "cert" {
	domain_name = "fa480.club"
	subject_alternative_names = ["*.fa480.club","*.staging.fa480.club"]
	validation_method = "DNS"
}

resource "aws_route53_zone" "main" {
  name         = "fa480.club"
}

resource "aws_route53_record" "apex_validation" {
  name = "${aws_acm_certificate.cert.domain_validation_options.0.resource_record_name}"
  type = "${aws_acm_certificate.cert.domain_validation_options.0.resource_record_type}"
  zone_id = "${aws_route53_zone.main.zone_id}"
  records = ["${aws_acm_certificate.cert.domain_validation_options.0.resource_record_value}"]
  ttl = 60
}

resource "aws_route53_record" "wildcard_validation" {
  name = "${aws_acm_certificate.cert.domain_validation_options.1.resource_record_name}"
  type = "${aws_acm_certificate.cert.domain_validation_options.1.resource_record_type}"
  zone_id = "${aws_route53_zone.main.zone_id}"
  records = ["${aws_acm_certificate.cert.domain_validation_options.1.resource_record_value}"]
  ttl = 60
}

resource "aws_route53_record" "staging_validation" {
  name = "${aws_acm_certificate.cert.domain_validation_options.2.resource_record_name}"
  type = "${aws_acm_certificate.cert.domain_validation_options.2.resource_record_type}"
  zone_id = "${aws_route53_zone.main.zone_id}"
  records = ["${aws_acm_certificate.cert.domain_validation_options.2.resource_record_value}"]
  ttl = 60
}

resource "aws_acm_certificate_validation" "cert" {
  certificate_arn = "${aws_acm_certificate.cert.arn}"
  validation_record_fqdns = [
    "${aws_route53_record.apex_validation.fqdn}",
    "${aws_route53_record.wildcard_validation.fqdn}",
    "${aws_route53_record.staging_validation.fqdn}"
  ]
}



resource "aws_route53_record" "www" {
  zone_id = "${aws_route53_zone.main.zone_id}"
  name    = "www.fa480.club"
  type    = "A"
  alias {
   name   = "${aws_lb.Load-Balancer.dns_name}"
   zone_id = "${aws_lb.Load-Balancer.zone_id}"
   evaluate_target_health = true
  }
}

resource "aws_route53_record" "www-staging" {
  zone_id = "${aws_route53_zone.main.zone_id}"
  name    = "www.staging.fa480.club"
  type    = "A"
  alias {
   name   = "${aws_lb.Load-Balancer.dns_name}"
   zone_id = "${aws_lb.Load-Balancer.zone_id}"
   evaluate_target_health = true
  }
}

resource "aws_route53_record" "blog" {
  zone_id = "${aws_route53_zone.main.zone_id}"
  name    = "blog.fa480.club"
  type    = "A"
  alias {
   name = "${aws_lb.Load-Balancer.dns_name}"
   zone_id = "${aws_lb.Load-Balancer.zone_id}"
   evaluate_target_health = true
  }
}

resource "aws_route53_record" "blog-staging" {
  zone_id = "${aws_route53_zone.main.zone_id}"
  name    = "blog.staging.fa480.club"
  type    = "A"
  alias {
   name   = "${aws_lb.Load-Balancer.dns_name}"
   zone_id = "${aws_lb.Load-Balancer.zone_id}"
   evaluate_target_health = true
  }
}


resource "aws_route53_record" "apex" {
  zone_id = "${aws_route53_zone.main.zone_id}"
  name    = "fa480.club"
  type    = "A"
  alias {
    name = "${aws_lb.Load-Balancer.dns_name}"
    zone_id = "${aws_lb.Load-Balancer.zone_id}"
    evaluate_target_health = true
  }  
}

resource "aws_route53_record" "apex-staging" {
  zone_id = "${aws_route53_zone.main.zone_id}"
  name    = "staging.fa480.club"
  type    = "A"
  alias {
   name   = "${aws_lb.Load-Balancer.dns_name}"
   zone_id = "${aws_lb.Load-Balancer.zone_id}"
   evaluate_target_health = true
  }
}

# Create a new instance of the latest Ubuntu Server on an
# t2.micro node with an AWS Tag naming it "Blog Server 2"

data "aws_ami" "ubuntu_server2" {
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

resource "aws_instance" "web2" {
  ami           = "ami-51537029"
  instance_type = "t2.micro"
  key_name = "${aws_key_pair.deployer.key_name}"
  vpc_security_group_ids = ["${aws_security_group.NATSG.id}"]
  subnet_id = "${aws_subnet.privsubnet1.id}"
  tags {
    Name = "Blog Server 2"
  }
}


# Create a new instance of the latest Ubuntu Server on an
# t2.micro node with an AWS Tag naming it "Blog Server 1"


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
  key_name = "${aws_key_pair.deployer.key_name}"
  vpc_security_group_ids = ["${aws_security_group.NATSG.id}"]
  subnet_id = "${aws_subnet.privsubnet1.id}"
  tags {
    Name = "Blog Server 1"
  }
}

resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAABJQAAAQEAspxdZSwwJDwGuJjT4uNWcrv5sZJEuVUESornDY8Dw/f7eg6lZNlj+kwt+wiAzIORJMJ3YDf5SgZzuG+cyvQT0qASP+B/c57xLyv/awatONR6rG1+KQ4nATg+rANe6efIc2Gx4Zx7avndbwGaR7S5S1WzYH2N5yg/BqEu5SZnI1xYa/eSCGeFmvazYtZtn9C5hpa8SocKcRD2tSKkdILKeVzz8SbMyuP9+gCY8PBXsaN1xA2m4niUa8bbWIPkMHavwhvfKmIu2noVdT6jAAeP93pO1mi47KA32qwO83e+fZRs+KDYp7qnOK0X/55pZKqWk89E6n8PefrwC4r5LbqZgQ== rsa-key-20180923"
  }


resource "aws_iam_instance_profile" "IP"{
  role = "${aws_iam_role.IR.name}" 

}

resource "aws_launch_configuration" "launch-config"{
  image_id = "ami-0bbe6b35405ecebdb"
  instance_type = "t2.micro"
  security_groups = ["${aws_security_group.NATSG.id}"]
  ebs_optimized = false
  key_name = "${aws_key_pair.deployer.key_name}"
  iam_instance_profile = "${aws_iam_instance_profile.IP.arn}"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "asg" {
  name                 = "BEATS-ASG"
  launch_configuration = "${aws_launch_configuration.launch-config.name}"
  min_size             = "1"
  max_size             = "2"
  desired_capacity     = "1"
  vpc_zone_identifier  = ["${aws_subnet.privsubnet1.id}"]  
  target_group_arns         = ["${aws_alb_target_group.HTTP-Group.arn}"]
  initial_lifecycle_hook{
     name = "BEATS-hook"
     heartbeat_timeout = 1500
     lifecycle_transition = "autoscaling:EC2_INSTANCE_LAUNCHING"
     default_result = "CONTINUE"

     notification_metadata = <<EOF
     {
       "a": "b"
     }
     EOF
     
     notification_target_arn = "arn:aws:sqs:us-west-2:1231231234:queue1*"
     role_arn = "${aws_iam_role.IR.arn}"

  }

  lifecycle {
    create_before_destroy = true
  }

  timeouts {
    delete = "30m"
  }

}

resource "aws_autoscaling_policy" "asg_policy" {
  name                   = "asg_policy"
  autoscaling_group_name = "${aws_autoscaling_group.asg.name}"
  policy_type = "TargetTrackingScaling"
  target_tracking_configuration {
  predefined_metric_specification {
    predefined_metric_type = "ASGAverageCPUUtilization"
  }
  target_value = 40.0
}
}






