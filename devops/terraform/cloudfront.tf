resource "aws_cloudfront_distribution" "cdn_distribution" {
enabled             = true
origin {
    domain_name = "${local.elb_id}"
    origin_id   = "${local.elb_id}"
    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "http-only"
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }

  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "${local.elb_id}"

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "allow-all"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  price_class = "PriceClass_200"

  restrictions {
    geo_restriction {
    #   restriction_type = "whitelist"
    #   locations        = ["US", "CA", "GB", "DE", "IN", "IR"]
      restriction_type = "none"
      locations = []
    }
  }

  tags = {
      Name = "topta-web"
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }

}
  