output site_website_endpoint {
    value = aws_s3_bucket.site.website_endpoint
}

output www_website_endpoint {
    value = aws_s3_bucket.www.website_endpoint
}

output site_bucket_arn {
    value = aws_s3_bucket.site.arn
}