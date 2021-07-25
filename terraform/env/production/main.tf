module "site_s3_buckets" {
    source = "../../modules/s3"
    domain = "${var.site_domain}"
    secret = "${var.secret}"
}

module "main_cdn" {
    source = "../../modules/cloudfront"
    domain = "${var.site_domain}"
    secret = "${var.secret}"
    s3_endpoint = module.site_s3_buckets.site_website_endpoint
    certificate_arn = module.ssl_certificate.certificate_validation_cert_arn
}

module "redirect_cdn" {
    source = "../../modules/cloudfront"
    domain = "www.${var.site_domain}"
    secret = "${var.secret}"
    s3_endpoint = module.site_s3_buckets.www_website_endpoint
    certificate_arn = module.ssl_certificate.certificate_validation_cert_arn
}

module "ssl_certificate" {
    source = "../../modules/acm"
    domain = "${var.site_domain}"
    zone_id = module.dns.zone_id
}

module "dns" {
    source = "../../modules/route53"
    domain = "${var.site_domain}"
    main_cdn_domain_name = module.main_cdn.cdn_domain_name
    redirect_cdn_domain_name = module.redirect_cdn.cdn_domain_name
    main_cdn_zone_id = module.main_cdn.cdn_hosted_zone_id
    redirect_cdn_zone_id = module.redirect_cdn.cdn_hosted_zone_id
}

module "iam" {
    source = "../../modules/iam"
    domain = "${var.site_domain}"
    bucket_arn = module.site_s3_buckets.site_bucket_arn
}
