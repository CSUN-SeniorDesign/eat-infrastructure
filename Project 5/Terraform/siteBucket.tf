

resource "aws_s3_bucket" "site_bucket" {
  bucket = "fa480.club"
  acl = "public-read"

 policy=<<EOF
{
   "Version":"2012-10-17",
   "Statement":[
     {
       "Sid":"PublicReadGetObject",
       "Effect":"Allow",
       "Principal":"*",
       "Action": [
         "s3:GetObject"  
       ],
       "Resource":["arn:aws:s3:::fa480.club/*"]

       }
   ]
}
 EOF
  website{
    index_document = "index.html"
    error_document = "index.html"
  }
  
    tags {
    Name = "Team Eat Bucket"
    Environment = "Dev"
  }
  versioning {
    enabled = true
  }
  lifecycle {
    prevent_destroy = false
  }

}

resource "aws_cloudfront_origin_access_identity" "origin_access_identity" {
  comment = "Test"
}



resource "aws_cloudfront_distribution" "s3_distribution" {
	origin{
		
		custom_origin_config {
      
      			http_port              = "80"
      			https_port             = "443"
      			origin_protocol_policy = "http-only"
      			origin_ssl_protocols   = ["TLSv1", "TLSv1.1", "TLSv1.2"]
		}		
				
		domain_name="${aws_s3_bucket.site_bucket.website_endpoint}"
		origin_id = "myS3Origin"

	}
	
	enabled = true
	is_ipv6_enabled = true
	default_root_object = "index.html"
	
	aliases = ["fa480.club","*.fa480.club"]
	
	default_cache_behavior {
		allowed_methods = ["GET","HEAD","OPTIONS"]
		cached_methods = ["GET","HEAD","OPTIONS"]
		target_origin_id="myS3Origin"
		compress=true

		forwarded_values{
			query_string = false
			cookies{
				forward="none"			
			}
		}
		viewer_protocol_policy  = "redirect-to-https"
		        min_ttl                = 0
    		        default_ttl            = 86400
			max_ttl = 31536000
	}

  	price_class = "PriceClass_100"

  	restrictions {
    		geo_restriction {
      			restriction_type = "whitelist"
      			locations        = ["US", "CA"]
    		}
  	}
	
	  viewer_certificate {
	    acm_certificate_arn = "${aws_acm_certificate.cert.arn}"
	    ssl_support_method="sni-only"
	  }

	
}

