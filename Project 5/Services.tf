
provider "aws" {
	region ="us-east-1"
	alias="usest"
}

resource "aws_acm_certificate" "cert" {
	provider="aws.usest"	
	domain_name = "fa480.club"
	subject_alternative_names = ["*.fa480.club"]
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

resource "aws_acm_certificate_validation" "cert" {
	provider="aws.usest"
  certificate_arn = "${aws_acm_certificate.cert.arn}"
  validation_record_fqdns = [
    "${aws_route53_record.apex_validation.fqdn}",
    "${aws_route53_record.wildcard_validation.fqdn}"
  ]
}


resource "aws_route53_record" "wildcard" {
  zone_id = "${aws_route53_zone.main.zone_id}"
  name    = "*.fa480.club"
  type    = "A"
  alias {
    name                   = "${aws_cloudfront_distribution.s3_distribution.domain_name}"
    zone_id                = "${aws_cloudfront_distribution.s3_distribution.hosted_zone_id}"
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "apex" {
  zone_id = "${aws_route53_zone.main.zone_id}"
  name    = "fa480.club"
  type    = "A"
  alias {
    name                   = "${aws_cloudfront_distribution.s3_distribution.domain_name}"
    zone_id                = "${aws_cloudfront_distribution.s3_distribution.hosted_zone_id}"
    evaluate_target_health = false
  }
}





