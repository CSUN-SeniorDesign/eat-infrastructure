resource "aws_lb" "Load-Balancer"{
  name               = "Load-Balancer"
  internal           = false
  load_balancer_type = "application"

  enable_deletion_protection = false
  
  subnets            = ["${aws_subnet.pubsubnet1.id}","${aws_subnet.pubsubnet2.id}","${aws_subnet.pubsubnet3.id}"]
}

resource "aws_route53_zone" "main" {
  name         = "fa480.club"
}

resource "aws_route53_zone" "blog" {
  name         = "blog.fa480.club"
}

resource "aws_route53_record" "www" {
  zone_id = "${aws_route53_zone.main.zone_id}"
  name    = "www.fa480.club"
  type    = "A"
  ttl     = "300"
  records = ["10.0.0.1"]
}
