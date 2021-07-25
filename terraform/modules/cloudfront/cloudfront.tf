resource "aws_cloudfront_distribution" "cdn" {
  enabled = true
  http_version = "http2"
  aliases = ["${var.domain}"]
  is_ipv6_enabled = true
  default_root_object = "index.html"

  origin {
    domain_name = "${var.s3_endpoint}"
    origin_id = "S3-${var.domain}"

    custom_origin_config {
      origin_protocol_policy = "http-only"
      http_port              = "80"
      https_port             = "443"
      origin_ssl_protocols = ["TLSv1"]
    }

    custom_header {
      name  = "User-Agent"
      value = "${var.secret}"
    }
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn = "${var.certificate_arn}"
    ssl_support_method = "sni-only"
    minimum_protocol_version = "TLSv1"
  }

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "S3-${var.domain}"
    compress = "true"
    viewer_protocol_policy = "redirect-to-https"
    min_ttl = 0
    default_ttl = 3600
    max_ttl = 86400

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }
  }
}